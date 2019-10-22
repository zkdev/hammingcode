import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class hammingcode {
    public static void main(String[] args) {
        run();
    }

    public static void run() {
        List<List<Integer>> bits = new ArrayList<>();

        // input
        Scanner scanner = new Scanner(System.in);
        System.out.print("input a hammingcode (X for 00011110000): ");
        String input = scanner.next();
        for (char c : input.toCharArray()) {
            if (c != '0' && c != '1' || input.length() < 2) {
                System.out.println("input denied, only hammingcodes (length > 2) are allowed");
                System.out.println("using default value instead (00011110000)\n");
                input = "00011110000";
            }
        }

        // flag parity bits
        for (int i = 1; i <= input.length(); i++) {
            List<Integer> temp = new ArrayList<>();
            // add input bit
            temp.add(Integer.parseInt(String.valueOf(input.charAt(i-1))));
            // flag as message bit
            temp.add(0);
            // update message flag to parity flag
            if ((i & (i - 1)) == 0) { temp.set(1, 1); }
            bits.add(temp);
        }

        // error detection and correction
        int flipped_bit = -1;
        for (int i = 1; i <= bits.size(); i++) {

            // is parity bit
            if (bits.get(i - 1).get(1) == 1) {

                // get message bits
                List<Integer> messagebits = new ArrayList<>();
                for (int j = i - 1; j < bits.size();) {
                    int h = 0;
                    for (int k = 0; k < i; k++) {
                        try {
                            messagebits.add(bits.get(j + k).get(0));
                            h = j + k;
                        } catch (IndexOutOfBoundsException ignored) {};
                    }
                    j = h + i + 1;
                }

                // parity bit itself still in messagebits
                messagebits.remove(0);

                // edge cases, dont want to tweak the working logic again
                if (!messagebits.isEmpty()) {
                    System.out.println("P" + i + " = " + bits.get(i-1).get(0) + " ; messagebits: " + messagebits);
                }

                // determine expected parity bit
                int ones = 0;
                for (int bit: messagebits) {
                    if (bit == 1) {
                        ones++;
                    }
                }
                int expected = 0;
                if (ones % 2 == 1) {
                    expected = 1;
                }

                // final error detection check
                if (bits.get(i - 1).get(0) != expected) {
                    System.out.println("error detected at P" + i);
                    flipped_bit = flipped_bit + i;
                }
            }
        }
        // trigger if error detected
        if (flipped_bit != -1) {
            System.out.println("\n===============================================");
            System.out.println("bitflip happend at position " + (flipped_bit + 1));
            List<Integer> result = new ArrayList<>();
            for (List<Integer> list : bits) {
                result.add(list.get(0));
            }
            System.out.println("input:     " + result);
            if (result.get(flipped_bit) == 0) {
                result.set(flipped_bit, 1);
            } else {
                result.set(flipped_bit, 0);
            }
            System.out.println("corrected: " + result);
            System.exit(0);
        }

        // output without error
        System.out.println("\n===============================================");
        System.out.println("no bitflip detected");
        System.exit(0);
    }
}
