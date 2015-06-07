using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CEUS.Wokshop.ProviderWeb.Models;

namespace CEUS.Wokshop.ProviderWeb.Utils
{
   public class PersonMockService:IPersonService
    {
       Person[] personRepository=  new Person[]
       {
           new Person{ Id=1,LastName = "Diaz",Name="Adrian"},
           new Person {Id=2,LastName = "Canales",Name="Marco"}
       };
       public IEnumerable<Person> GetAll()
       {
           return personRepository;
       }

       public Person GetById(int id)
       {          
           return personRepository.FirstOrDefault((p) => p.Id == id);;
       }
    }
}
