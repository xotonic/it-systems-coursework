using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace it_systems_coursework
{
    public class Order
    {
        public Order()
        {
            date = DateTime.Now;
            software.Add(new Software { producer = "AVAST", name = "Free Antivirus", price = 999.0f });
            software.Add(new Software { producer = "AVAST", name = "Net Filter", price = 999.0f });
        }
        public bool active { set; get; }
        public string customer { set; get; }
        public string address { set; get; }
        public int count_hard { set; get; }
        public int count_soft { set; get; }
        public string software_list { get
         {
                string list = "";
                foreach (var s in software)
                {
                    list += String.Format("{0} {1}\n", s.producer, s.name);
                }
                if (software.Count == 0) list = "Нет";
                return list;
            } }
        public string hardware_list { get
            {
                string list = "";
                foreach (var s in computers)
                {
                    list += String.Format("{0} {1}\n", s.producer, s.name);
                }
                if (computers.Count == 0) list = "Нет";
                return list;
            } }

        //public int current_count { set; get; }
        public DateTime date { set; get; }

        public List<Computer> computers = new List<Computer>();
        public List<Software> software = new List<Software>();

        public override string ToString()
        {
            return String.Format("{0}: {1} на {2} ({3}/{4} ПО; {5}/{6} ПК)", 
                active ? "Активный" : "Неактивный" ,
                customer, 
                date.ToShortDateString(),
                software.Count, count_soft, 
                computers.Count, count_hard);
        }
    }
}
