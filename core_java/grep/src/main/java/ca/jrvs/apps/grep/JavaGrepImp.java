package ca.jrvs.apps.grep;

import org.apache.log4j.BasicConfigurator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.*;

public class JavaGrepImp implements JavaGrep {

    final Logger logger = LoggerFactory.getLogger(JavaGrep.class);

    private String regex;
    private String rootPath;
    private String outFile;

    public static void main(String[] args) {
        if (args.length != 3) {
            throw new IllegalArgumentException("USAGE: JavaGrep regex rootPath outFile");
        }

        BasicConfigurator.configure();

        JavaGrepImp javaGrepImp = new JavaGrepImp();
        javaGrepImp.setRegex(args[0]);
        javaGrepImp.setRootPath(args[1]);
        javaGrepImp.setOutFile(args[2]);

        try {
            javaGrepImp.process();
        } catch (IOException e) {
            javaGrepImp.logger.error("Error: Unable to process", e);
        }


    }

    /**
     * Top level search workflow
     * @throws IOException
     */
    public void process() throws IOException {
        List<String> matchedLines = new ArrayList<>();

        for(File file: listFiles(getRootPath())){
            for(String line: readLines(file)){
                if(containsPattern(line)){
                    matchedLines.add(line);
                }
            }
        }

        writeToFile(matchedLines);

    }

    /**
     * Traverse a given directory and return all files
     * @param rootDir input directory
     * @return List<File> files under the rootDir
     */
    public List<File> listFiles(String rootDir) {
        File currentFile = new File(rootDir);
        List<File> files = new ArrayList<>();

        if (currentFile.isDirectory()) {
            if(currentFile.listFiles() != null) {
                for (File file : currentFile.listFiles()) {
                    files.addAll(listFiles(file.getAbsolutePath()));
                }
            }
        } else {
            files.add(currentFile);
        }

        return files;
    }

    /**
     * Read a file and return all the lines
     * @param inputFile path to file
     * @return List<String> list of lines
     */
    public List<String> readLines(File inputFile) {
        List<String> lines = new ArrayList<>();

        try{
            BufferedReader reader = new BufferedReader(new FileReader(inputFile));
            String line = reader.readLine();
            while(line != null){
                lines.add(line);
                line = reader.readLine();
            }
            reader.close();
        } catch (IOException e) {
            logger.error("Error: Unable to read file", e);
        }

        return lines;
    }

    /**
     * Check if a line contains the regex pattern (passed in by user)
     * @param line a line of text
     * @return boolean
     */
    public boolean containsPattern(String line) {
        try {
            Pattern pattern = Pattern.compile(getRegex());
            Matcher matcher = pattern.matcher(line);
            return matcher.find();
        } catch (PatternSyntaxException e) {
            logger.error("Error: Invalid regex pattern", e);
        }
        return false;
    }

    /**
     * Write lines to a file
     * @param lines lines of text to be written to the output file
     * @throws IOException
     */
    public void writeToFile(List<String> lines) throws IOException {
        try {

            BufferedWriter writer = new BufferedWriter( new FileWriter(getOutFile()));
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
            writer.close();

        } catch (IOException e) {
            logger.error("Error: Unable to write to file", e);
        }
    }

    /**
     * Get root directory path
     * @return String
     */
    public String getRootPath() {
        return this.rootPath;
    }

    /**
     * Set root directory path
     * @param rootPath
     */
    public void setRootPath(String rootPath) {
        this.rootPath = rootPath;
    }

    /**
     * Get regex pattern
     * @return String
     */
    public String getRegex() {
        return this.regex;
    }

    /**
     * Set regex pattern
     * @param regex
     */
    public void setRegex(String regex) {
        this.regex = regex;
    }


    /**
     * Get the output file path
     * @return String
     */
    public String getOutFile() {
        return this.outFile;
    }

    /**
     * Set the output file path
     * @param outFile
     */
    public void setOutFile(String outFile) {
        this.outFile = outFile;
    }
}
