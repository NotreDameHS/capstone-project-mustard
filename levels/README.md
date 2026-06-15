# Levels

### What goes here?
The "stages" of your game. This is where you bring all your **Entities** together to create a playable experience.
* **Contents:** `level_01.tscn`, level-specific background scenes, and environmental layouts.

### Why?
Levels act as the **Container**. While an "Entity" (like a Gem) knows how to be a gem, the "Level" knows *where* those gems are placed and how the player progresses from start to finish. Keeping levels separate from entities prevents your project from becoming a "flat" list of confusing scenes.
