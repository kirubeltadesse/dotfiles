<!--toc:start-->

- [Dependencies](#dependencies)
  - [Reading a QR Code](#reading-a-qr-code)
  - [Adding the otpauth string](#adding-the-otpauth-string)
  - [Generating a OTP](#generating-a-otp)
  <!--toc:end-->

## Dependencies

You will need the `pass`, `pass-otp` and `zbar` packages. On arch linux you can install them with the following command:

`pacman -S pass pass-otp zbar`

### Reading a QR Code

With zbar, it is quite easy to decode a QR code, you don’t need some Google Authenticate app for that! Just save the image, or take a screenshot of the QR code and then simply run:

`zbarimg -q <the QR Code image file>`

Keep that string, you will need it in a second!

### Adding the otpauth string

You can save the otpauth string very similar to how you would insert a new entry in pass:

`pass otp add <a name of your choosing>`

You enter the string starting with otpauth://… that you got from zbar.
And that’s pretty much it for the setup.

### Generating a OTP

To generate the One-Time-Password you simply run:

`pass otp <the name you chose before>`

And there you go, a One-Time-Password, directly generated from your shell, no phone involved!
