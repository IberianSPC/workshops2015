using System.Collections.Generic;
using CEUS.Wokshop.ProviderWeb.Models;

namespace CEUS.Wokshop.ProviderWeb.Utils
{
    public interface IPersonService
    {
        IEnumerable<Person> GetAll();
        Person GetById(int id);
    }
}
