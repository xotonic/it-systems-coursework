using Npgsql;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace it_systems_coursework
{
    public class Order
    {

        public int id;
        public string customer { set; get; }
        public string address { set; get; }
        public string opened { set; get; }
        public string closed { set; get; }
        public string firstname { set; get; }
        public string secondname { set; get; }

        public string software_list
        {
            get
            {
                string list = "";
                foreach (var s in software)
                {
                    list += String.Format("{0} {1}\n", s.producer, s.name);
                }
                if (software.Count == 0) list = "Нет";
                return list;
            }
        }
        public string hardware_list
        {
            get
            {
                string list = "";
                foreach (var s in computers)
                {
                    list += String.Format("{0} {1}\n", s.producer, s.name);
                }
                if (computers.Count == 0) list = "Нет";
                return list;
            }
        }


        public List<Computer> computers = new List<Computer>();
        public List<Software> software = new List<Software>();

        public override string ToString()
        {
            return string.Format("{0}:{1})",
                customer,
                opened);
        }

        static public Order createFromRow(NpgsqlDataReader reader)
        {
            var o = new Order();
            o.id = reader.GetInt32(0);
            o.customer = reader.GetString(1);
            o.address = reader.GetString(2);
            o.opened = reader.GetDate(3).ToString();
            try
            {
                o.closed = reader.GetDate(4).ToString();
            }
            catch (InvalidCastException) { o.closed = "-"; }
            o.firstname = reader.GetString(5);
            o.secondname = reader.GetString(5);

            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = string.Format("select * from ordered_computers({0})", o.id);
                    var r = cmd.ExecuteReader();
                    while (r.Read())
                    {
                        var pc = new Computer()
                        {
                            id_object = r.GetInt32(0),
                            producer = r.GetString(1),
                            name = r.GetString(2),
                            price = (float)r.GetDouble(3)
                        };
                        o.computers.Add(pc);
                    }
                }
            }
            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = string.Format("select * from ordered_software({0})", o.id);
                    var r = cmd.ExecuteReader();
                    while (r.Read())
                    {
                        var pc = new Software()
                        {
                            id_object = r.GetInt32(0),
                            producer = r.GetString(1),
                            name = r.GetString(2),
                            price = (float)r.GetDouble(3)
                        };
                        o.software.Add(pc);
                    }
                }
            }

            return o;
        }
    }
}
