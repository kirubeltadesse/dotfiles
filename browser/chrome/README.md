# Chrome extension files

[Here](https://crxextractor.com/) is the link to create `.crx` file fore any extension you want.

## Exporting Bookmarks

Next, mouse over "Bookmarks" and select "Bookmark Manager."
Hover over

On the Bookmark Manager page, click the three-dot menu icon in the top blue bar and select "Export Bookmarks."
Click the menu icon and select

This will create an HTML file that contains all of your bookmarks. Now you can choose where you want to save the file. Rename the file if you want
and click "Save" when you've picked a location.
Choose a location and

That's all there is to it! You can use the HTML file to set up a new browser, but don't forget to delete your bookmarks that are no longer needed.
Take good care of your precious bookmarks!

Related: How to Create, View, and Edit Bookmarks in Google Chrome

## Vimium

In this directory, you will find the `.crx` file for Vimium, and you can directly add it to your Chrome browser.

After adding Vimium, you can click on options, and at the bottom of the page, you will see `Backup and Restore`. You can upload a `.json` file using previous shortcuts. You will find a `vimium-options.json` to get the shortcuts I use.

`ctrl + space` keyboards will disable and enable `vomnibar`.

Note: disabling will help you use the normal keyboard shortcut for `Youtube` like speeding up (.) and down (,) muting video (m) , caption (c), increasing (up arrow) and decreasing volume (down arrow).

### Select and search on Vimium

- https://superuser.com/questions/1236864/how-to-use-vimium-to-select-text-from-a-page

## Browser pass plugin

- Make sure the `.browserpass.json` file exists in the `.password-store` directory.

Needs gpgtools.org and download and install

### Key trusting issues solution

```bash
gpg --edit-key <KEY_ID>
gpg> trust
```

Since the key is created my me. I will select 5

```bash
Your decision? 5
Do you really want to set this key to ultimate trust? (y/N) y
```

After confirming, quit with:

```bash
gpg> quit
```
