using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Security;
using System.Text;
using System.Threading.Tasks;
using Microsoft.SharePoint.Client;

namespace CEUS.Wokshop.ProviderWeb.Utils
{
    public static class SharePointContext
    {
        public static ClientContext GetClientContext()
        {
            var fullUrl = "";
            

            var clientContext = new ClientContext(fullUrl);
            var pass = new SecureString();
            foreach (var c in "pass")
            {
                pass.AppendChar(c);
            }
            clientContext.Credentials = new SharePointOnlineCredentials("",
                pass);
            return clientContext;
        }
    
    

    }
}
