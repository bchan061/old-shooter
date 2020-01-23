<p align="center">
  <img src="Resources/iTunesArtwork" alt="Shootup Survival iTunes Artwork"/>
  <br/>
  <b>Shootup Survival - 2012</b>
</p>

Endless arcade shoot-em-up with upgradable weapons and various enemy types.

## Tools
The original prototype was written in Microsoft XNA with C#. Unfortunately, I lost the code a while back.
This iOS version was made with Cocos2D and was originally targeted towards iOS 5.
Music was made with GarageBand, sounds were generated with sfxr.
Art was created with Paint.NET (on school laptops!)

## What's cool?
- This app was made when automatic reference counting (ARC) was just added in iOS 5, so I had to learn new features with web tutorials instead of paper books.

## What's not cool?
- Power ups spawn during a break and not during a wave. This makes it possible to lock yourself out of a usable weapon if you have 0 points while you're fighting.

## Lessons
- There are smarter ways for inheritance with entities - you'll notice that the entities are sprites with hardcoded differences according to their ID.
- Don't add a feature right before deploying for production! The power up mistake could have easily been fixed with 5 more minutes of testing.
