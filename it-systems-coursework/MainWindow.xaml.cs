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

        public MainWindow()
        {
            InitializeComponent();
            computers.Add(new Computer { name = "Aspire V5-561G", producer = "Acer", count = 2 });
            computers.Add(new Computer { name = "Thinkpad V3", producer = "Lenovo", count = 1 });

            HardwareListView.ItemsSource = computers;
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
                computers.RemoveAt(index);
            }
            HardwareListView.ItemsSource = null;
            HardwareListView.ItemsSource = computers;
        }
    }
}
