using Npgsql;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace it_systems_coursework
{
    /// <summary>
    /// Логика взаимодействия для Autorization.xaml
    /// </summary>
    public partial class Autorization : Window
    {
        public Autorization()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = string.Format("select * from check_user('{0}', '{1}')", tb_login.Text, tb_password.Password);
                    var reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        SQLUtils.userlogin = tb_login.Text;
                        SQLUtils.userpassword = tb_password.Password;
                        SQLUtils.userfirstname = reader.GetString(0);
                        SQLUtils.usersecondname = reader.GetString(1);
                        SQLUtils.useradmin = reader.GetBoolean(2);
                        DialogResult = true;
                    }
                    else {
                        MessageBox.Show("Неправильный логин или пароль, или все вместе");
                        DialogResult = false;
                    }
                    //if (cmd.ExecuteNonQuery() == 0)
                    //   MessageBox.Show("Не удается войти. Обратитесь к администратору");
                }
            }
        }
    }
}
