import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JTextPane;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import javax.swing.border.BevelBorder;

public class Calculator {
	private static JTextPane userText;
	
	public static void main(String[] args) throws 	ClassNotFoundException, 
													InstantiationException, 
													IllegalAccessException, 
													UnsupportedLookAndFeelException {
		
		// UI Elements
		JButton scanButton = new JButton("Scan (Lexical Analysis)");
		JButton parseButton = new JButton("Parse (Syntax Analysis)");
		userText = new JTextPane();
		
		// Set properties for TextPane
		userText.setPreferredSize(new Dimension(400, 175));
		userText.setText("read A\nread B\nsum := A + B\nwrite sum\nwrite sum / 2");
		userText.setBorder(BorderFactory.createBevelBorder(BevelBorder.LOWERED));
		
		scanButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				
				try {
					BufferedWriter writer = new BufferedWriter(new FileWriter("input.txt"));
					writer.write(userText.getText());
					writer.newLine();
					writer.close();
				} catch (FileNotFoundException e1) {
					e1.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				// It's windows, so use DOS commands
				if(System.getProperty("os.name").toLowerCase().indexOf("win") >= 0) {
					String removeTextCommand = "DEL tokens.txt";
					try {
						Process child = Runtime.getRuntime().exec(removeTextCommand);
					} catch (IOException e1) {
						e1.printStackTrace();
					}
				}
				// It's probably mac or linux
				else {
					String removeTextCommand = "rm tokens.txt";
					try {
						Process child = Runtime.getRuntime().exec(removeTextCommand);
					} catch (IOException e1) {
						e1.printStackTrace();
					}
				}
				
				String executeLexCommand = "racket lex.rkt -e go";
				try {
					Process child = Runtime.getRuntime().exec(executeLexCommand);
				} catch (IOException e1) {
					e1.printStackTrace();
				}
			}
		});
		
		UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());

		// Set window properties
	    JFrame f = new JFrame("Calculator (Lexer and Parser)");
	    f.setSize(500, 250);
	    f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		Container content = f.getContentPane();
	    content.setBackground(Color.white);
	    content.setLayout(new FlowLayout());
	    
	    content.add(scanButton);
	    content.add(parseButton);
	    content.add(userText);
	    f.setVisible(true);
	}
	
}
