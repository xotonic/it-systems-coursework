using Npgsql;
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
        public int id_producer, id_model, id_object;
        public string name { set; get; }
        public string producer { set; get; }
        public float price { set; get; }
        public float ram { set; get; }
        public float hdd { set; get; }
        public int cores { set; get; }
        public float freq { set; get; }
        public float gpu { set; get; }

        public override string ToString()
        {
            return String.Format("{0} {1} [{2}]", producer, name, price);
        }

        static public Computer createFromRow(NpgsqlDataReader reader)
        {
            var comp = new Computer();
            comp.id_producer = reader.GetInt32(0);
            comp.id_model = reader.GetInt32(1);
            comp.id_object = reader.GetInt32(2);

            comp.producer = reader.GetString(3);
            comp.name = reader.GetString(4);
            comp.price = (float)reader.GetDouble(5);
            comp.ram = (float)reader.GetDouble(6);
            comp.hdd = (float)reader.GetDouble(7);
            comp.cores = reader.GetInt32(8);
            comp.freq = (float)reader.GetDouble(9);
            comp.gpu = (float)reader.GetDouble(10);
            return comp;
        }

        public void deleteFromDatabase()
        {
            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = String.Format("select delete_computer({0})", id_object);
                    if (cmd.ExecuteNonQuery() == 0)
                        MessageBox.Show("Не удается удалить запись. Обратитесь к администратору");
                }
            }
        }

        public void insertToDatabase(int count)
        {
            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    for (int i = 0; i < count; i++)
                    {
                        cmd.CommandText = String.Format("select insert_computer('{0}','{1}',{2},{3},{4},{5},{6},{7})",
                            producer, name, price, ram, hdd, cores, freq, gpu);
                        if (cmd.ExecuteNonQuery() == 0)
                            MessageBox.Show("Ошибка добавления записи в базу данных. Обратитесь к администратору");
                    }

                }
            }
        }

        public void updateInDatabase()
        {
            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = String.Format("select * from update_computer({0},{1},{2},'{3}','{4}',{5},{6},{7},{8},{9},{10})",
                        id_object, id_model, id_producer, producer, name, price, ram, hdd, cores, freq, gpu);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read() == true)
                        {
                            id_object = reader.GetInt32(0);
                            id_model = reader.GetInt32(1);
                            id_producer = reader.GetInt32(2);
                        }
                    }
                }
            }
        }
    }
}
