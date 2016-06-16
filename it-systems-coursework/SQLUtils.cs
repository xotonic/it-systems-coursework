using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Npgsql;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using System.Windows;

namespace it_systems_coursework
{
    public static class SQLUtils
    {
        /* public static string server="localhost", 
                               username="postgres", 
                               password="postgres", 
                               database="geekandgop";
         public static int port=5433;*/
        public static ConnectParams connectParams = new ConnectParams();

        private static string connect_params
        { get { return string.Format("Host={0};Username={1};Password={2};Database={3};Port={4}",
           connectParams.server, connectParams.username, connectParams.password, connectParams.database, connectParams.port); }
        }

        public static NpgsqlConnection CreateAndOpen()
        {
            var conn = new NpgsqlConnection(connect_params);
            conn.Open();
            return conn;
        }

        public static string userfirstname, usersecondname, userlogin, userpassword;
        public static bool useradmin;

        public static bool autorize()
        {
            return (bool) new Autorization().ShowDialog();
        }


        static public void SerializeObject<T>(T serializableObject, string fileName)
        {
            if (serializableObject == null) { return; }

            try
            {
                XmlDocument xmlDocument = new XmlDocument();
                XmlSerializer serializer = new XmlSerializer(serializableObject.GetType());
                using (MemoryStream stream = new MemoryStream())
                {
                    serializer.Serialize(stream, serializableObject);
                    stream.Position = 0;
                    xmlDocument.Load(stream);
                    xmlDocument.Save(fileName);
                    stream.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Не удалось сохранить файл");
            }
        }

        static public T DeSerializeObject<T>(string fileName)
        {
            if (string.IsNullOrEmpty(fileName)) { return default(T); }

            T objectOut = default(T);

            try
            {
                XmlDocument xmlDocument = new XmlDocument();
                xmlDocument.Load(fileName);
                string xmlString = xmlDocument.OuterXml;

                using (StringReader read = new StringReader(xmlString))
                {
                    Type outType = typeof(T);

                    XmlSerializer serializer = new XmlSerializer(outType);
                    using (XmlReader reader = new XmlTextReader(read))
                    {
                        objectOut = (T)serializer.Deserialize(reader);
                        reader.Close();
                    }

                    read.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Не удалось загрузить файл");

            }

            return objectOut;
        }

    }
}
