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
            InitializeComponent();

            //computers.Add(new Computer { name = "Aspire V5-561G", producer = "Acer", price = 2 });
            //computers.Add(new Computer { name = "Thinkpad V3", producer = "Lenovo", price = 1 });

            //software.Add(new Software { name = "NOD32 Antivirus", producer = "ESET", price = 1199.0f });
            //software.Add(new Software { name = "Fallout 4", producer = "Bethesda Softworks", price = 1999.0f });

            orders.Add(new Order { customer = "DNS", address = "пл.Маркса 69", count_soft = 10, count_hard = 10 });
            orders.Add(new Order { customer = "НГТУ", address = "Немидовича-Данченко 139", count_soft = 0, count_hard = 30 });


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

            HardwareListView.ItemsSource = computers;
            SoftwareListView.ItemsSource = software;
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


        }

        private void ClickUpdateOrder(object sender, RoutedEventArgs e)
        {
            var sel = OrderListView.SelectedItems;
            foreach (var item in sel)
            {
                AddOrder addpc = new AddOrder(item as Order);
                addpc.ShowDialog();
            }
            OrderListView.ItemsSource = null;
            OrderListView.ItemsSource = orders;

        }

        private void ClickDeleteOrder(object sender, RoutedEventArgs e)
        {
            while (OrderListView.SelectedItems.Count > 0)
            {
                var index = OrderListView.Items.IndexOf(OrderListView.SelectedItem);
                orders.RemoveAt(index);
            }
            OrderListView.ItemsSource = null;
            OrderListView.ItemsSource = orders;
        }
    }
}
