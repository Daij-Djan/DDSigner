DDSigner
========

Small OSX Sample App that does RFC-3852 Encryption of any file using the Apple's CMS API (10.7+).

The Encryption & Signing is provided by two classes.
- <b>DDSecureMessage</b> acts as a container for the data, the keys for signature and optionally the keys for encryption. 
- <b>DDSecureMessageCoder</b> can encode a prepared SecureMessage using Apple's CMS API (sign and optionally encrypt). It can also decode NSData initializing a SecureMessage with the decoded NSData and the certificates of the signers.

Besides this main task, DDSecureMessage also has two convenience methods. One to find private keys for signers by email, the other to find public keys of recipients (for which to encrypt the message) by email.

- To Learn more about the RFC 3852 used here visit [Wikipedia here](http://en.wikipedia.org/wiki/Cryptographic_Message_Syntax)
- To Learn more about PKI in general visit [Wikipedia here](http://en.wikipedia.org/wiki/Public_key_infrastructure)

###Motivation
The primary reason for the publication of this software is to make CMS and also PKI more widely known and used in software on the mac. (and on other platforms.)<br/>
