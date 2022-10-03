package in.ankitpati.zip;

import java.io.IOException;
import java.util.zip.Deflater;
import java.util.zip.DeflaterInputStream;

@SuppressWarnings("PMD.SystemPrintln")
public class InputDeflater {
    public static void main(String[] args) throws IOException {
        if (args.length != 0) {
            System.err.println("Usage:\n\tjava InputDeflater < input.txt > output.dfl");
            System.exit(1);
        }

        try (DeflaterInputStream inputStream =
                new DeflaterInputStream(System.in, new Deflater(Deflater.DEFLATED, true))) {
            inputStream.transferTo(System.out);
        }
    }
}
