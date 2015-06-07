using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using CEUS.Wokshop.ProviderWeb.Models;
using Microsoft.SharePoint.Client;

namespace CEUS.Wokshop.ProviderWeb.Utils
{
   public class PersonService:IPersonService
    {
        public IEnumerable<Person> GetAll()
        {
            var spContext = SharePointContext.GetClientContext();

            var spList = spContext.Web.Lists.GetByTitle("Person");
            spContext.Load(spList);
            spContext.ExecuteQuery();
            if (spList == null || spList.ItemCount <= 0) return null;
            var camlQuery = new CamlQuery
            {
                ViewXml = @"<View>             
                                <RowLimit>20</RowLimit> 
                             </View>",
                DatesInUtc = true
            };
            var listItems = spList.GetItems(camlQuery);
            spContext.Load(listItems);
            spContext.ExecuteQuery();
            var resultItems = new List<Person>();

            foreach (var item in listItems)
            {
                var personItem = new Person
                {
                    Id = item.Id,
                    Name = item["Name"].ToString(),
                    LastName = item["LastName"].ToString()
                };
                resultItems.Add(personItem);
            }

            return resultItems;
        }

        public Person GetById(int id)
        {
            try
            {
                var spContext = SharePointContext.GetClientContext();

                var spList = spContext.Web.Lists.GetByTitle("Person");
                spContext.Load(spList);
                spContext.ExecuteQuery();
                if (spList == null || spList.ItemCount <= 0) return null;

                var listItems = spList.GetItemById(id);
                spContext.Load(listItems);
                spContext.ExecuteQuery();
                if (listItems == null) return null;
                var personItem = new Person
                {
                    Id = listItems.Id,
                    Name = listItems["Name"].ToString(),
                    LastName = listItems["LastName"].ToString()
                };


                return personItem;
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}
