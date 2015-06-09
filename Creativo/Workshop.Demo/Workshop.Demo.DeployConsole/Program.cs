using Microsoft.SharePoint.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Workshop.Demo.DeployConsole
{
    class Program
    {

        internal static char[] trimChars = new char[] { '/' };

        static void Main(string[] args)
        {
            var isOnline = false;
            SharePointOnlineCredentials credentials = null;
            if (GetSPType() == "online")
                isOnline = true;

            var operation = GetOperation();
            //var username = GetUserName();
            var username = "sporras@sporras.onmicrosoft.com";
            var password = GetPassword();

            credentials = new SharePointOnlineCredentials(username, password);

            args = new string[2] { "activate", "online" };

            //activate or deactivate the branding

            var branding = XDocument.Load("branding-settings.xml").Element("branding");
            var url = branding.Attribute("url").Value;

            foreach (var site in branding.Element("sites").Descendants("site"))
            {
                var siteUrl = url.TrimEnd(trimChars) + "/" + site.Attribute("url").Value.TrimEnd(trimChars);
                using (ClientContext clientContext = new ClientContext(siteUrl))
                {
                    if (isOnline)
                    {
                        clientContext.Credentials = credentials;
                    }

                    clientContext.Load(clientContext.Web);
                    clientContext.ExecuteQuery();
                    switch (args[0].ToLower())
                    {
                        case "activate":
                            UploadFiles(clientContext, branding);
                            UploadMasterPages(clientContext, branding);
                            //UploadPageLayouts(clientContext, branding);
                            break;
                        case "deactivate":
                            RemoveFiles(clientContext, branding);
                            RemoveMasterPages(clientContext, branding);
                            RemovePageLayouts(clientContext, branding);
                            break;
                    }
                }
            }
            Console.WriteLine("Done!");
            Console.ReadLine();
        }

        private static string GetOperation()
        {
            var result = "-1";
            while (result != "0" && result != "1")
            {
                Console.WriteLine("Selecciones el tipo de operación que va a realizar:");
                Console.WriteLine("  1: Activar");
                Console.WriteLine("  0: Desactivar");
                result = Console.ReadLine();
                if (result == "0")
                    return "deactivate";
                else
                    if (result == "1")
                        return "activate";
            }

            return string.Empty;
        }

        private static string GetSPType()
        {
            var result = "-1";
            while (result != "0" && result != "1")
            {
                Console.WriteLine("Online / OnPremises:");
                Console.WriteLine("  1: Online");
                Console.WriteLine("  0: OnPremises");
                result = Console.ReadLine();
                if (result == "0")
                    return "onpremises";
                else
                    if (result == "1")
                        return "online";
            }
            return "online";
        }

        #region "activate branding functions"

        private static void UploadFiles(ClientContext clientContext, XElement branding)
        {
            foreach (var file in branding.Element("files").Descendants("file"))
            {
                var name = file.Attribute("name").Value;
                var folder = file.Attribute("folder").Value.TrimEnd(trimChars);
                var path = file.Attribute("path").Value.TrimEnd(trimChars);
                var location = file.Attribute("location").Value.TrimEnd(trimChars);

                BrandingHelper.UploadFile(clientContext, name, folder, path, location);
            }
        }

        private static void UploadMasterPages(ClientContext clientContext, XElement branding)
        {
            foreach (var masterpage in branding.Element("masterpages").Descendants("masterpage"))
            {
                var name = masterpage.Attribute("name").Value;
                var folder = masterpage.Attribute("folder").Value.TrimEnd(new char[] { '/' });

                BrandingHelper.UploadMasterPage(clientContext, name, folder);
            }
        }

        private static void UploadPageLayouts(ClientContext clientContext, XElement branding)
        {
            foreach (var pagelayout in branding.Element("pagelayouts").Descendants("pagelayout"))
            {
                var name = pagelayout.Attribute("name").Value;
                var folder = pagelayout.Attribute("folder").Value.TrimEnd(trimChars);
                var publishingAssociatedContentType = GetAttribute(pagelayout, "publishingAssociatedContentType");
                var title = GetAttribute(pagelayout, "title");

                BrandingHelper.UploadPageLayout(clientContext, name, folder, title, publishingAssociatedContentType);
            }
        }

        private static string GetAttribute(XElement node, string attrName)
        {
            var attribute = node.Attribute(attrName);
            if (attribute == null)
                return string.Empty;
            return attribute.Value;

        }

        #endregion

        #region "deactivate branding functions"

        private static void RemoveFiles(ClientContext clientContext, XElement branding)
        {
            var name = "";
            var folder = "";
            var path = "";
            foreach (var file in branding.Element("files").Descendants("file"))
            {
                name = file.Attribute("name").Value;
                folder = file.Attribute("folder").Value.TrimEnd(trimChars);
                path = file.Attribute("path").Value.TrimEnd(trimChars);

                BrandingHelper.RemoveFile(clientContext, name, folder, path);
            }
            BrandingHelper.RemoveFolder(clientContext, folder, path);
        }

        private static void RemoveMasterPages(ClientContext clientContext, XElement branding)
        {
            var name = "";
            var folder = "";
            foreach (var masterpage in branding.Element("masterpages").Descendants("masterpage"))
            {
                name = masterpage.Attribute("name").Value;
                folder = masterpage.Attribute("folder").Value.TrimEnd(new char[] { '/' });

                BrandingHelper.RemoveMasterPage(clientContext, name, folder);
            }
            BrandingHelper.RemoveFolder(clientContext, folder, "_catalogs/masterpage");
        }

        private static void RemovePageLayouts(ClientContext clientContext, XElement branding)
        {
            foreach (var pagelayout in branding.Element("pagelayouts").Descendants("pagelayout"))
            {
                var name = pagelayout.Attribute("name").Value;
                var folder = pagelayout.Attribute("folder").Value.TrimEnd(trimChars);
                var publishingAssociatedContentType = pagelayout.Attribute("publishingAssociatedContentType").Value;
                var title = pagelayout.Attribute("title").Value;

                BrandingHelper.RemovePageLayout(clientContext, name, folder);
            }
        }

        #endregion

        #region "helper functions"

        static SecureString GetPassword()
        {
            SecureString sStrPwd = new SecureString();

            try
            {
                Console.Write("SharePoint Password: ");

                for (ConsoleKeyInfo keyInfo = Console.ReadKey(true); keyInfo.Key != ConsoleKey.Enter; keyInfo = Console.ReadKey(true))
                {
                    if (keyInfo.Key == ConsoleKey.Backspace)
                    {
                        if (sStrPwd.Length > 0)
                        {
                            sStrPwd.RemoveAt(sStrPwd.Length - 1);
                            Console.SetCursorPosition(Console.CursorLeft - 1, Console.CursorTop);
                            Console.Write(" ");
                            Console.SetCursorPosition(Console.CursorLeft - 1, Console.CursorTop);
                        }
                    }
                    else if (keyInfo.Key != ConsoleKey.Enter)
                    {
                        Console.Write("*");
                        sStrPwd.AppendChar(keyInfo.KeyChar);
                    }

                }
                Console.WriteLine("");
            }
            catch (Exception e)
            {
                sStrPwd = null;
                Console.WriteLine(e.Message);
            }

            return sStrPwd;
        }

        static string GetUserName()
        {
            string strUserName = string.Empty;
            try
            {
                Console.Write("SharePoint Username: ");
                strUserName = Console.ReadLine();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                strUserName = string.Empty;
            }
            return strUserName;
        }

        static void DisplayUsage()
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine("Please specify 'activate' or 'deactivate' and optionally 'online'");
            Console.ForegroundColor = ConsoleColor.Yellow;
            Console.WriteLine("Example 1 (SharePoint Online): \n Contoso.Branding.ApplyBranding.Console.exe activate online");
            Console.WriteLine("Example 2 (SharePoint Online):  \n Contoso.Branding.ApplyBranding.Console.exe deactivate online");
            Console.WriteLine("Example 3 (SharePoint On-premises):  \n Contoso.Branding.ApplyBranding.Console.exe activate");
            Console.WriteLine("Example 4 (SharePoint On-premises):  \n Contoso.Branding.ApplyBranding.Console.exe deactivate");
            Console.ResetColor();
        }

        #endregion

    }
}
