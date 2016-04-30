using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace it_systems_coursework
{
    public class Computer
    { 
        public string name { set; get; }
        public string producer { set; get; }
        public uint count { set; get; }

        public override string ToString()
        {
            return String.Format("{0} {1} [{2}]", producer, name, count);
        }


    }
}
