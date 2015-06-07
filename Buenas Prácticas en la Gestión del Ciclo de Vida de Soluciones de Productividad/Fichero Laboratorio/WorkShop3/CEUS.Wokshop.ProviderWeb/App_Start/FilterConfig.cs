using System.Web;
using System.Web.Mvc;

namespace CEUS.Wokshop.ProviderWeb
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
