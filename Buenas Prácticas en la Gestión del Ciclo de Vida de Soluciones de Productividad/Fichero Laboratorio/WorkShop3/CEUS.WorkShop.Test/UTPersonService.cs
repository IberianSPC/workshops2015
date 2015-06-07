using System;
using System.Linq;
using CEUS.Wokshop.ProviderWeb.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CEUS.WorkShop.Test
{
    [TestClass]
    public class UTPersonService
    {
        private IPersonService personService;

        [TestInitialize]
        public void Init()
        {
            personService=new PersonService();
        }
        [TestMethod]
        public void GetAll()
        {
            var result = personService.GetAll();

            Assert.AreEqual(result.Any(),true);
        }

        [TestMethod]
        public void GetByIdFail()
        {
            var result = personService.GetById(99);

            Assert.AreEqual(result==null, true);
        }
        [TestMethod]
        public void GetById()
        {
            var result = personService.GetById(1);

            Assert.AreEqual(result.Id==1, true);
        }
    }
}
