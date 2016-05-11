using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace it_systems_coursework
{
    public class Software
    {
        public string name { set; get; }
        public string producer { set; get; }
        public float price { set; get; }

        public override string ToString()
        {
            return String.Format("{0} {1} [{2}]", producer, name, price);
        }
    }
}
