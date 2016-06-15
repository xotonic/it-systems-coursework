using Npgsql;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace it_systems_coursework
{
    public class Software
    {
        public int id_producer, id_model, id_object;
        public string name { set; get; }
        public string producer { set; get; }
        public float price { set; get; }

        public override string ToString()
        {
            return String.Format("{0} {1} [{2}]", producer, name, price);
        }

        static public Software createFromRow(NpgsqlDataReader reader)
        {
            var comp = new Software();
            comp.id_producer = reader.GetInt32(0);
            comp.id_model = reader.GetInt32(1);
            comp.id_object = reader.GetInt32(2);

            comp.producer = reader.GetString(3);
            comp.name = reader.GetString(4);
            comp.price = (float)reader.GetDouble(5);
            
            return comp;
        }

        public void deleteFromDatabase()
        {
            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = String.Format("select delete_software({0})", id_object);
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
                        cmd.CommandText = String.Format("select insert_software('{0}','{1}',{2})",
                            producer, name, price);
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
                    cmd.CommandText = String.Format("select * from update_software({0},{1},{2},'{3}','{4}',{5})",
                        id_object, id_model, id_producer, producer, name, price);
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
