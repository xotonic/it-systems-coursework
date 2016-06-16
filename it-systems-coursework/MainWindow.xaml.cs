using Npgsql;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace it_systems_coursework
{


    public partial class MainWindow : Window
    {
        ObservableCollection<Computer> computers = new ObservableCollection<Computer>();
        ObservableCollection<Software> software = new ObservableCollection<Software>();
        ObservableCollection<Order> orders = new ObservableCollection<Order>();

        public MainWindow()
        {
            while (SQLUtils.autorize() == false)
            { }

            InitializeComponent();

            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = "select * from computers_all_with_id()";
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var comp = Computer.createFromRow(reader);
                            computers.Add(comp);
                        }
                    }
                }
            }

            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = "select * from software_all_with_id()";
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var sw = Software.createFromRow(reader);
                            software.Add(sw);
                        }
                    }
                }
            }

            updateOrders();

            HardwareListView.ItemsSource = computers;
            SoftwareListView.ItemsSource = software;
        }

        private void updateOrders()
        {
            orders.Clear();
            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = string.Format("select * from find_orders('', '{0}','{1}')", SQLUtils.userlogin, SQLUtils.userpassword);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var sw = Order.createFromRow(reader);
                            orders.Add(sw);
                        }
                    }
                }
            }
            OrderListView.ItemsSource = null;
            OrderListView.ItemsSource = orders;

        }

        private void ClickAddComputer(object sender, RoutedEventArgs e)
        {
            AddComputer addpc = new AddComputer();
            if (addpc.ShowDialog() == true)
                computers.Add(addpc.computer);

        }

        private void ClickUpdateComputer(object sender, RoutedEventArgs e)
        {
            var sel = HardwareListView.SelectedItems;
            foreach (var item in sel)
            {
                AddComputer addpc = new AddComputer(item as Computer);
                addpc.ShowDialog();
            }
            HardwareListView.ItemsSource = null;
            HardwareListView.ItemsSource = computers;

        }

        private void ClickDeleteComputer(object sender, RoutedEventArgs e)
        {
            while (HardwareListView.SelectedItems.Count > 0)
            {
                var index = HardwareListView.Items.IndexOf(HardwareListView.SelectedItem);
                var comp = HardwareListView.SelectedItem as Computer;
                comp.deleteFromDatabase();
                computers.RemoveAt(index);
            }
            HardwareListView.ItemsSource = null;
            HardwareListView.ItemsSource = computers;
        }

        private void ClickFilterComputer(object sender, RoutedEventArgs e)
        {
            string str = filterbox.Text;

            computers.Clear();
            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = string.Format("select * from find_computers('{0}')", str);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var comp = Computer.createFromRow(reader);
                            computers.Add(comp);
                        }
                    }
                }
            }
        }

        private void ClickClearFilter(object sender, RoutedEventArgs e)
        {
            filterbox.Text = "";
            ClickFilterComputer(null, null);
        }

        private void ClickFilterSoftware(object sender, RoutedEventArgs e)
        {
            string str = swfilterbox.Text;

            software.Clear();
            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = string.Format("select * from find_software('{0}')", str);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var sw = Software.createFromRow(reader);
                            software.Add(sw);
                        }
                    }
                }
            }
        }

        private void ClickClearFilterSoftware(object sender, RoutedEventArgs e)
        {
            swfilterbox.Text = "";
            ClickFilterSoftware(null, null);
        }

        private void ClickAddSoftware(object sender, RoutedEventArgs e)
        {

            AddSoftware addpc = new AddSoftware();
            if (addpc.ShowDialog() == true)
                software.Add(addpc.software);
        }

        private void ClickUpdateSoftware(object sender, RoutedEventArgs e)
        {
            var sel = SoftwareListView.SelectedItems;
            foreach (var item in sel)
            {
                AddSoftware addpc = new AddSoftware(item as Software);
                addpc.ShowDialog();
            }
            SoftwareListView.ItemsSource = null;
            SoftwareListView.ItemsSource = software;

        }

        private void ClickDeleteSoftware(object sender, RoutedEventArgs e)
        {
            while (SoftwareListView.SelectedItems.Count > 0)
            {
                var index = SoftwareListView.Items.IndexOf(SoftwareListView.SelectedItem);
                var comp = SoftwareListView.SelectedItem as Software;
                comp.deleteFromDatabase();

                software.RemoveAt(index);
            }
            SoftwareListView.ItemsSource = null;
            SoftwareListView.ItemsSource = software;
        }

        private void ClickAddOrder(object sender, RoutedEventArgs e)
        {

            AddOrder addpc = new AddOrder();
            if (addpc.ShowDialog() == true)
                orders.Add(addpc.order);

            updateOrders();
        }

        private void ClickCloseOrder(object sender, RoutedEventArgs e)
        {
            var sel = OrderListView.SelectedItems;
            foreach (var item in sel)
            {
                //AddOrder addpc = new AddOrder(item as Order);
                //addpc.ShowDialog();
                var o = item as Order;
                using (var conn = SQLUtils.CreateAndOpen())
                {
                    using (var cmd = new NpgsqlCommand())
                    {
                        cmd.Connection = conn;
                        cmd.CommandText = string.Format("select close_order({0})", o.id);
                        if (cmd.ExecuteNonQuery() == 0)
                            MessageBox.Show("Не удается сделать запись. Обратитесь к администратору");
                    }
                }
            }
            updateOrders();

        }

        private void ClickCancelOrder(object sender, RoutedEventArgs e)
        {
            var sel = OrderListView.SelectedItems;
            foreach (var item in sel)
            {
                //AddOrder addpc = new AddOrder(item as Order);
                //addpc.ShowDialog();
                var o = item as Order;
                using (var conn = SQLUtils.CreateAndOpen())
                {
                    using (var cmd = new NpgsqlCommand())
                    {
                        cmd.Connection = conn;
                        cmd.CommandText = string.Format("select cancel_order({0})", o.id);
                        if (cmd.ExecuteNonQuery() == 0)
                            MessageBox.Show("Не удается сделать запись. Обратитесь к администратору");
                    }
                }
            }
            updateOrders();

        }

        //public

        private List<Computer> attachingPC = new List<Computer>();
        private List<Software> attachingSW = new List<Software>();

        private void AttachSW(object sender, RoutedEventArgs e)
        {
            var sel =  SoftwareListView.SelectedItems;
            foreach (var s in sel) attachingSW.Add(s as Software);

            GoodsTabControl.SelectedIndex = 2;
            GoodsTabControl.SelectedItem = orders_tabitem;
            orders_tabitem.IsSelected = true;
            accept_order.Visibility = Visibility.Visible;

        }

        private void AttachPC(object sender, RoutedEventArgs e)
        {
            var sel = HardwareListView.SelectedItems;
            foreach (var s in sel) attachingPC.Add(s as Computer);

            GoodsTabControl.SelectedIndex = 2;
            GoodsTabControl.SelectedItem = orders_tabitem;
            orders_tabitem.IsSelected = true;
            accept_order.Visibility = Visibility.Visible;
            
        }

        private void AttachToOrder(object sender, RoutedEventArgs e)
        {
            int order_id = 0;
            try
            {
                order_id = (OrderListView.SelectedItem as Order).id;
            }
            catch (NullReferenceException) {
                MessageBox.Show("Вы не выбрали заказ");
                attachingPC.Clear();
                attachingSW.Clear(); return;
            }
            foreach (var s in attachingSW)
            {
                using (var conn = SQLUtils.CreateAndOpen())
                {
                    using (var cmd = new NpgsqlCommand())
                    {
                        cmd.Connection = conn;
                        cmd.CommandText = string.Format("select attach_software({0}, {1})", s.id_object, order_id);
                        if (cmd.ExecuteNonQuery() == 0)
                            MessageBox.Show("Не удается сделать запись. Обратитесь к администратору");
                    }
                }
            }

            foreach (var s in attachingPC)
            {
                using (var conn = SQLUtils.CreateAndOpen())
                {
                    using (var cmd = new NpgsqlCommand())
                    {
                        cmd.Connection = conn;
                        cmd.CommandText = string.Format("select attach_computer({0}, {1})",  s.id_object, order_id);
                        if (cmd.ExecuteNonQuery() == 0)
                            MessageBox.Show("Не удается сделать запись. Обратитесь к администратору");
                    }
                }
            }
            attachingPC.Clear();
            attachingSW.Clear();
            accept_order.Visibility = Visibility.Collapsed;
            updateOrders();
        }

        private void update_periods(object sender, RoutedEventArgs e)
        {
            var top_pc = new ObservableCollection<Computer>();
            var top_sw = new ObservableCollection<Software>();

            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = string.Format("select * from period_computers('{0}','{1}')", 
                        date_from.SelectedDate.ToString(), date_to.SelectedDate.ToString());
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var comp = new Computer();//.createFromRow(reader);
                            comp.producer = reader.GetString(0);
                            comp.name = reader.GetString(1);
                            comp.price = (float)reader.GetDouble(2);

                            top_pc.Add(comp);
                        }
                    }
                }
            }

            TopHardwareListView.ItemsSource = top_pc;

            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = string.Format("select * from period_software('{0}','{1}')",
                        date_from.SelectedDate.ToString(), date_to.SelectedDate.ToString());
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var comp = new Software();//.createFromRow(reader);
                            comp.producer = reader.GetString(0);
                            comp.name = reader.GetString(1);
                            comp.price = (float)reader.GetDouble(2);

                            top_sw.Add(comp);
                        }
                    }
                }
            }

            TopSoftwareListView.ItemsSource = top_sw;
        }

        private void update_tops(object sender, RoutedEventArgs e)
        {
            var top_pc = new ObservableCollection<Computer>();
            var top_sw = new ObservableCollection<Software>();

            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = "select * from top_computers()";
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var comp = new Computer();//.createFromRow(reader);
                            comp.producer = reader.GetString(0);
                            comp.name = reader.GetString(1);
                            comp.price = (float)reader.GetInt32(2);

                            top_pc.Add(comp);
                        }
                    }
                }
            }

            PopularHardwareListView.ItemsSource = top_pc;

            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = "select * from top_software()";
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var comp = new Software();//.createFromRow(reader);
                            comp.producer = reader.GetString(0);
                            comp.name = reader.GetString(1);
                            comp.price = (float)reader.GetInt32(2);

                            top_sw.Add(comp);
                        }
                    }
                }
            }

            PopularSoftwareListView.ItemsSource = top_sw;
        }
    }
}
