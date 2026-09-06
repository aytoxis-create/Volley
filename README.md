## 🧪 Technologies

This project was developed with the following technologies:

- [Lua]
- [Javascript]
- [NodeJS]

## 🚀 How to install and run the project

You must have Node JS installed on your machine. Visit the page to download [Node JS Website](https://nodejs.org/en/download/).

Clone the project

```bash
$ git clone https://github.com/Soristl/Volley.git

$ npm i (to install the dependencies)
$ npm run minify (to generate the volley.lua file)
```

With the volley.lua file generated, open Transformice, go to your tribe's house, type the command /lua and paste it into the game's code interface

## Room Creator

The first eligible player in a new room automatically becomes its Room Creator and receives regular admin permissions. The role appears in `!admins` / `!ads`. The Get Admin button and the old admin assignment based on the room name have been removed.

Regular admins cannot remove the Room Creator's admin rights. Temporary permanent and permanent admins (levels 3–5) can use `!unadmin Name#0000`, `!ua Name#0000`, or `!unadmin all`. Higher staff permissions are preserved.

The creator remains the same for the script session, including after leaving and returning. Rights removed by staff stay removed across rounds and reconnects; they can be explicitly granted again with `!admin`. There is no automatic transfer of ownership.

When the script starts with one eligible player already present, that player becomes the creator. If several players are already present, the script cannot reconstruct their arrival order and does not assign a creator. Test room creation in a new room or start the script while alone.

## Player profile

Press `P`, type `!profile` or `!pr` to open your player card. Use `!profile Name#0000` (case-insensitive) to inspect another player's profile from the current room session. A nickname without its discriminator is accepted when it matches exactly one player.

The card shows the player's role, matches, victories, win rate and room rank for Normal, 2 teams, 3 teams, 4 teams and Real mode. Rankings use the same ordering as the existing room leaderboard. Players without matches are unranked. Statistics cover the current script session and are not saved permanently.

Click a trophy to inspect its description and the viewed player's collection count. On your own profile, an earned trophy can still be displayed above your mouse using **Show trophy**. Mode tabs keep the same viewed player and do not reload trophy images. Closing with `P` or **Close**, opening another panel, and leaving the room clean up the profile.

## 💻 Project

Volley is currently a semi-official Transformice module created to bring fun to people.

## 📝 License

This project is licensed under the MIT License. See the file [LICENSE](https://github.com/Soristl/Volley/blob/main/LICENSE) for more details.
