package in.ankitpati.zip;

import java.io.IOException;
import java.util.zip.Inflater;
import java.util.zip.InflaterInputStream;

@SuppressWarnings("PMD.SystemPrintln")
public class InputInflater {
    public static void main(String[] args) throws IOException {
        if (args.length != 0) {
            System.err.println("Usage:\n\tjava InputInflater < input.dfl > output.txt");
            System.exit(1);
        }

        try (InflaterInputStream inputStream =
                new InflaterInputStream(System.in, new Inflater(true))) {
            inputStream.transferTo(System.out);
        }
    }
}
