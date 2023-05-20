using System;

namespace First_Prj
{
    class Program
    {
        static void Main(string[] args)
        {

            int x;
            Console.WriteLine("Plz enter a num:");
            string number = Console.ReadLine();
            x = int.Parse(number);
            x *= 3;
            Console.WriteLine(x);
            Console.WriteLine("Press any key to exit...");
            Console.ReadKey();
        }
    }
}
