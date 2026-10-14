# NetControl | (Holloway) Chew, Kean Ho

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

The `(Holloway) Chew, Kean Ho's NetControl` is a localized offline network fleet
management repository. Its primary and sole purpose is to restore an entire
organization's networking infrastructure seamlessly inside a fully offline
(no Internet, obviously) operating environment, across various network operating
systems like [OpenWRT](https://openwrt.org/).

The project is designed to solve the following pain points:

* **Version-Controlled Network Settings for Proprietary Environments** - ensures
  no room for error and permits reliable rollback for proprietary network
  settings across the entire fleet.
* **Operate Freely Across Operating Systems** - program (or reprogram) the
  entire network infrastructure anywhere without limitation: `FreeBSD`, `Linux`,
  etc.
* **Simple Tools To Get The Job Done** - built using simple POSIX Shell scripts
  with no programming dependencies to install.
* **Designed for Network Engineers by an Experienced Network Maintainer** - all
  features and facilities are designed by experienced people, from deep,
  first-hand empathy and painful experiences.
* **No Complicated Manual GUI Setup Work** - all done using programmable scripts
  instead of a GUI.
* **Works Offline** - obviously, in a "No Internet" environment. After all, you
  are fixing the organization's network.
* **Manageable Scalability** - a small home network, small and medium
  businesses, and large area coverage can all be done and managed through this
  simple technology.
* **Private Internet Capable** - no more ruthless artificial intelligence
  scraping of private data without consent: build your very own private
  Internet!




## To "Install" and Use

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)



### Clone The Git Repository

To ensure you're safe while maintaining your organizational network, it is
**HIGHLY** recommended to keep a `git` repository copy on your workstation
(e.g. a laptop).

The best way is to clone the repository:

```
$ git clone <url> --branch main --single-branch
```

The available `<url>` values are:

* **Global**: [https://github.com/ChewKeanHo/software-netcontrol.git](https://github.com/ChewKeanHo/software-netcontrol.git)
* **European Union (EU)**: [https://codeberg.org/chewkeanho/software-netcontrol.git](https://codeberg.org/chewkeanho/software-netcontrol.git)



### Develop/Place Your Configurations

The repository itself is a control surface. Now, you can either port or develop
the configuration for each hardware node device into the respective operating
system location:

* **OpenWRT** - `etc/openwrt/config/[NODE_NAME]/`

The `[NODE_NAME]` refers to the node itself, used privately here (e.g.
`mesh-MACADDR`, `repeater-MACADDR`, `leaf-MACADDR`).

This project supports the following node types:

* **Mesh** - the main routing node device that governs the entire network, with
  `802.11s` mesh networking built in by default.
* **Repeater** - the repeater node device that expands both wired and wireless
  network range using the `802.11s` mesh networking backhaul.
* **Leaf** - the leaf-end node device that interprets the `802.11s` mesh network
  back into usable interfaces for clients.

With these built-in networks:

* **`ROOT`** - the only wired access into the main routing node.
* **`TRUSTED`** - the trusted network for servers and devices.
* **`IOT`** - the no-Internet (unless exempted) network for Internet-of-Things
  devices.
* **`TESTER`** - the sandbox environment of the network.
* **`GUEST`** - the isolated guest-only network.
* **`BACKHAUL` and `MESH`** - the management networks for the `802.11s` mesh
  networking.

Examples and templates (**COMING SOON**) will be available in the
`share/openwrt/config/example/` directory.



### Program a Test Node

Once your configurations are completed, you can begin to program each node by:

```
$ ./bin/chewkeanho-netcontrol bootstrap [PROFILE_NAME] [IP_ADDRESS]
```

Debug the settings here until you get reliable results. This is for future
restoration in case of the node's hardware failure.



### Reliably Install Packages

Some settings require packages to be reliably installed or swapped over. This
project has you covered:

```
$ ./bin/chewkeanho-netcontrol add|remove [PACKAGE] [PROFILE_NAME] [IP_ADDRESS]
```

To check out what is supported, use the following commands:

```
$ ./bin/chewkeanho-netcontrol help package              # list
$ ./bin/chewkeanho-netcontrol help package [PACKAGE]    # specific package
```



### Securely Lock/Unlock Your Settings

Now that everything is done, use the following command to securely lock your
enterprise settings with standard cryptography policies and a password:

```
$ ./bin/chewkeanho-netcontrol lock [FILENAME_WITHOUT_EXTENSION]
...
$ ./bin/chewkeanho-netcontrol unlock [FILENAME].tar.xz.enc
...
```

> [!IMPORTANT]
>
> **ALWAYS KEEP IT LOCKED AT ALL TIMES.**
>
> Only unlock when you need to program or develop it.
>
> The network is the nervous system of an organization.
> **PLEASE TAKE THE SECURITY SERIOUSLY**.

In its encrypted locked form, you can save the encrypted archive (e.g.
`myorg-network.tar.xz.enc`) into your secure password manager like
[KeePassXC](https://keepassxc.org/).



### Update The Repository

To update the repository:

```
$ git pull
```



### Learn More

Simple! Use the following command and follow the breadcrumb:

```
$ ./bin/chewkeanho-netcontrol help
```




## Verifying Content Integrity

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

To secure the content from unauthorized modification by anyone, down to the bit
level (`0|1`), all files are cryptographically signed using one or more
cryptography tools such as but not limited to:

* [GnuPG](https://gnupg.org); AND/OR
* [OpenSSL](https://www.openssl.org/).

The public key and the associated certificate are attached. Only the main owner
keeps and maintains the private keys. To verify the content's integrity:



### GnuPG

You should also download the following from the same portal:

1. the package's GPG/PGP detached signature (the associated `.asc` file); AND
2. the signing public key (`public-key.gpg`)


#### Download and Install GnuPG

For GnuPG software, you can source it from the
[GnuPG official website](https://gnupg.org/). Follow the instructions therein to
properly install it.


#### Confirming Key Origin

The command to display the key's fingerprint is:

```
$ gpg --no-default-keyring --fingerprint --show-keys /path/to/public-key.gpg
```

Then look for:

```
pub   ed25519 2020-01-13 [C]
      49B7 8787 4910 7ED9 C456  267A CFD3 316C 2987 3FB5
```

If it matches, that means the public key is indeed from the original owner
itself.

Otherwise, treat this as a sign of tampering: switch to a new mirror and restart
the verification.


#### Verify the Package Integrity

To verify the package integrity, the command is as follows:

```
$ gpg --no-default-keyring --keyring /path/to/public-key.gpg --verify [PACKAGE].asc [PACKAGE]
```

If GnuPG reports a good signature, the content is intact.

Otherwise, the package is tainted and you **MUST** remove it at all costs. Try
downloading from another mirror and restart the content integrity verification.



### OpenSSL

1. Install [OpenSSL](https://www.openssl.org) software if not present.
2. Download the target file and its detached signature file (the `.sig`/`.sign`
   file with the same filename).
3. Download the public certificate file (`.pem`) containing the public key
   within.
4. Place them next to each other in the directory.
5. Open a terminal and execute the following command:

```
$ openssl dgst -verify /path/to/pubkey.pem -signature /path/to/file.sig /path/to/file
```




## Artificial Intelligence (A.I.) Decrees

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

Please refer to [AI_DECREES.md](AI_DECREES.md) for the project's policy on the
use of Artificial Intelligence.




## Cryptography Policies

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

Please refer to [CRYPTOGRAPHY.md](CRYPTOGRAPHY.md) for the project's policy on
the use of cryptography.




## Maintainers' Notes

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

Please refer to [CONTRIBUTING.md](CONTRIBUTING.md) for contributing &
maintenance guidelines.




## License

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

This entire repository is licensed under
[The 3-Clause BSD License (`BSD-3-Clause`)](LICENSE.txt). To ensure better
understanding of this license, the following sub-sections will briefly describe
how to deploy the content.

For registered non-profit organizations (NGOs), you are considered a
`Commercial Entity` the same as any for-profit organization by default. However,
you will be eligible for the NGO disbursement grant and receive exception
privileges from the creator(s).



### Attribution

Unless otherwise specified, you **MUST** attribute back to the creator(s) as
follows:

```
Title: (Holloway) Chew, Kean Ho's NetControl
Creators: (Holloway) Chew, Kean Ho
Packaged-By: (Holloway) Chew, Kean Ho
Contact: hello@chewkeanho.com
SKU: chewkeanho-software-netcontrol
UUID: EDBC3094-7C57-4B71-96F6-AC3F818BB819
License: BSD 3-Clause "New" or "Revised" License (https://opensource.org/license/BSD-3-clause)
Repository Made On: 2026-10-05
Repository Made From: Malaysia, South East Asia
Procure: https://github.com/ChewKeanHo/software-netcontrol
```



### Ownership - Personal

> [!NOTE]
>
> This targets any customer wanting to own a copy of the content and then only
> he/she is using it without sharing with any 3rd-party entity; AND **WITHOUT**
> any monetary intention such as but not limited to:
>
> * Saving a local copy and then viewing via his/her own mobile device(s); OR
> * Saving a local copy and then viewing via his/her own personal computer; OR
> * Saving a local copy for artificial intelligence data training purposes.

You are **ALLOWED** provided you:

1. retain all the copyright notice, owners, contributors, disclaimers and etc.
2. any form be it source or compiled binary MUST reproduce the above copyright
   notice, owners, contributors, disclaimers, and etc.
3. **PROHIBITED** from using any copyright holder and contributor name for any
   use including but not limited to endorse or promote products derived from
   here without specific prior written permission.



### Ownership - Commercial

> [!NOTE]
>
> This targets any customer wanting to own a copy of the content and then only
> he/she is using it without sharing with any 3rd-party entity; AND **WITH** any
> monetary intention such as but not limited to:
>
> * Saving a local copy for enhancing his/her company's procurement list; OR
> * Saving a local copy for commercial artificial intelligence data training
>   purposes.

You are **ALLOWED** provided you:

1. retain all the copyright notice, owners, contributors, disclaimers and etc.
2. any form be it source or compiled binary MUST reproduce the above copyright
   notice, owners, contributors, disclaimers, and etc.
3. **PROHIBITED** from using any copyright holder and contributor name for any
   use including but not limited to endorse or promote products derived from
   here without specific prior written permission.



### Reference - Personal & Commercial

> [!NOTE]
>
> This targets any customer wanting to refer or to provide a guide for sourcing
> the original content for any 3rd-party entity **without directly displaying
> any portion of the original content**; **WITHOUT** any monetary intention such
> as but not limited to:
>
> * Academic research and paper writing; OR
> * New content creation linking to the original content **WITHOUT displaying
>   any of the original content** for his/her own streaming platform; OR
> * Content production and collection linking to original content **WITHOUT
>   displaying any of the original content**; OR
> * Web portfolio project linking to the original content **WITHOUT displaying
>   any of the original content**; OR
> * Event materials linking the original content **WITHOUT displaying any of the
>   original content**; OR
> * Meeting materials linking the original content **WITHOUT displaying any of
>   the original content**; OR
> * Advertisement contents linking the original content **WITHOUT displaying any
>   of the original content**.

You are **ALLOWED** provided you:

1. retain all the copyright notice, owners, contributors, disclaimers and etc.
2. any form be it source or compiled binary MUST reproduce the above copyright
   notice, owners, contributors, disclaimers, and etc.
3. **PROHIBITED** from using any copyright holder and contributor name for any
   use including but not limited to endorse or promote products derived from
   here without specific prior written permission.



### Integration - Personal

> [!NOTE]
>
> This targets any customer wanting to directly **display portions and NOT ALL**
> of the original content **as it is OR without any composing remixes or
> modifications retaining the original intent, art direction and messages** into
> his/her content creation; **WITHOUT** any monetary intention such as but not
> limited to:
>
> * New content creation with displaying portion(s) of the original content for
>   his/her own streaming platform **without any monetary gain**; OR
> * Content production and collection with displaying portion(s) of the original
>   content **without any monetary gain**; OR
> * Web portfolio project with displaying portion(s) of the original content
>   **without any monetary gain**; OR
> * Event materials with displaying portion(s) of the original content
>   **without any monetary gain**; OR
> * Meeting materials with displaying portion(s) of the original content
>   **without any monetary gain**.

You are **ALLOWED** provided you:

1. retain all the copyright notice, owners, contributors, disclaimers and etc.
2. any form be it source or compiled binary MUST reproduce the above copyright
   notice, owners, contributors, disclaimers, and etc.
3. **PROHIBITED** from using any copyright holder and contributor name for any
   use including but not limited to endorse or promote products derived from
   here without specific prior written permission.



### Integration - Commercial

> [!NOTE]
>
> This targets any customer wanting to directly **display portions and NOT ALL**
> of the original content **as it is OR without any composing remixes or
> modifications retaining the original intent, art direction and messages** into
> his/her content creation; **WITH** any monetary intention such as but not
> limited to:
>
> * New content creation with displaying portion(s) of the original content for
>   his/her own streaming platform; OR
> * Content production and collection with displaying portion(s) of the original
>   content; OR
> * Web portfolio project with displaying portion(s) of the original content; OR
> * Event materials with displaying portion(s) of the original content; OR
> * Meeting materials with displaying portion(s) of the original content; OR
> * Advertisement materials with displaying portion(s) of the original content.

You are **ALLOWED** provided you:

1. retain all the copyright notice, owners, contributors, disclaimers and etc.
2. any form be it source or compiled binary MUST reproduce the above copyright
   notice, owners, contributors, disclaimers, and etc.
3. **PROHIBITED** from using any copyright holder and contributor name for any
   use including but not limited to endorse or promote products derived from
   here without specific prior written permission.



### Composition Remix - Personal

> [!NOTE]
>
> This targets any customer wanting to own and then **modify the original
> content extensively preserving or altering the original intent, art direction,
> or message** for composing his/her new content creation; **WITHOUT** any
> monetary intention such as but not limited to:
>
> * New content creation with digitally modified and processed original content
>   integration for his/her own streaming platform **WITHOUT** any profits
>   including advertisement commission; OR
> * Personal content production and collection with digitally modified and
>   processed original content integration for his/her own streaming platform
>   **WITHOUT** any profits including advertisement commission; OR
> * Personal web portfolio project with digitally modified and processed
>   original content integration for his/her own streaming platform **WITHOUT**
>   any profits including advertisement commission; OR
> * Social media meme content creation with digitally modified and processed
>   original content integration for his/her own streaming platform **WITHOUT**
>   any profits including advertisement commission.

You are **ALLOWED** provided you:

1. retain all the copyright notice, owners, contributors, disclaimers and etc.
2. any form be it source or compiled binary MUST reproduce the above copyright
   notice, owners, contributors, disclaimers, and etc.
3. **PROHIBITED** from using any copyright holder and contributor name for any
   use including but not limited to endorse or promote products derived from
   here without specific prior written permission.



### Composition Remix - Commercial

> [!NOTE]
>
> This targets any customer wanting to own and then **modify the original
> content extensively preserving or altering the original intent, art direction,
> or message** for composing his/her new content creation; **WITH** any monetary
> intention such as but not limited to:
>
> * New content creation with digitally modified and processed original content
>   integration for his/her own streaming platform; OR
> * Personal content production and collection with digitally modified and
>   processed original content integration for his/her own streaming platform;
>   OR
> * Personal web portfolio project with digitally modified and processed
>   original content integration for his/her own streaming platform; OR
> * Social media meme content creation with digitally modified and processed
>   original content integration for his/her own streaming platform.

You are **ALLOWED** provided you:

1. retain all the copyright notice, owners, contributors, disclaimers and etc.
2. any form be it source or compiled binary MUST reproduce the above copyright
   notice, owners, contributors, disclaimers, and etc.
3. **PROHIBITED** from using any copyright holder and contributor name for any
   use including but not limited to endorse or promote products derived from
   here without specific prior written permission.



### Broadcast or Resell Redistribution - Personal

> [!NOTE]
>
> This targets any customer wanting to share, to broadcast, to re-distribute,
> to sell, or to re-sell the original, **modified, OR derived** content
> **WITHOUT** any monetary intention such as but not limited to:
>
> * Sharing with family members; OR
> * Streaming the content via any streaming platform with private viewer access;
>   OR
> * Displaying the content in his/her gallery with privately invited guests; OR
> * Displaying the content in private, free entry open spaces like living room;
>   OR
> * Owning a copy of the original content and serving it as downloadable content
>   on a website in a private network (e.g. self-hosted home network); OR
> * Sharing the original content across social media or messaging applications
>   like email or instant messenger.

You are **ALLOWED** provided you:

1. retain all the copyright notice, owners, contributors, disclaimers and etc.
2. any form be it source or compiled binary MUST reproduce the above copyright
   notice, owners, contributors, disclaimers, and etc.
3. **PROHIBITED** from using any copyright holder and contributor name for any
   use including but not limited to endorse or promote products derived from
   here without specific prior written permission.



### Broadcast or Resell Redistribution - Commercial

> [!NOTE]
>
> This targets any customer wanting to share, to broadcast, to re-distribute,
> to sell, or to re-sell the original, **modified, OR derived** content
> **WITH** any monetary intention such as but not limited to:
>
> * Streaming the content via any streaming platform with public or private
>   viewer access; OR
> * Displaying the content in any company's public events with free or payable
>   guest invites; OR
> * Displaying the content in any company's internal/private events with free or
>   payable guest invites; OR
> * Owning a copy of the original content and serving it as free OR payable
>   downloadable content on his/her website in any network (Internet, Intranet,
>   or private networks); OR
> * Sharing the original content across social media or messaging applications
>   like email or instant messenger; OR
> * Distributing the original content via multiple profit-earning streaming
>   platforms.

You are **ALLOWED** provided you:

1. retain all the copyright notice, owners, contributors, disclaimers and etc.
2. any form be it source or compiled binary MUST reproduce the above copyright
   notice, owners, contributors, disclaimers, and etc.
3. **PROHIBITED** from using any copyright holder and contributor name for any
   use including but not limited to endorse or promote products derived from
   here without specific prior written permission.
