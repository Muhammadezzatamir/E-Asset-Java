/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.utils;

/**
 *
 * @author Acer
 */
public class EncryptionDemo {
    public static void main(String[] args) {
        try {
            String plainPassword = "abc123";
            String encrypted = CryptoUtil.encrypt(plainPassword);
            String decrypted = CryptoUtil.decrypt(encrypted);

            System.out.println("Encrypted: " + encrypted);
            System.out.println("Decrypted: " + decrypted);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}


