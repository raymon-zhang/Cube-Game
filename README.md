# Cube-Game
This is a 3d voxel game made I made during covid, using Processing. It is heavily based off of Minecraft.


# Playing the game
To play the game, visit the [releases](https://github.com/raymon-zhang/Cube-Game/releases). 
Download the correct zip according to your operating system. Once downloaded, extract the files, and go inside the game folder, RaymonGame, and run the executable. 

# Hi
Hello

# Screenshots
![Screenshot (1)](https://user-images.githubusercontent.com/65573069/226516167-f130fb4e-6a05-417e-971b-3dff9cd53729.png)
![Screenshot (2)](https://user-images.githubusercontent.com/65573069/226516407-83e71504-4165-46e1-8eac-b09f7e8ea817.png)
![Screenshot (3)](https://user-images.githubusercontent.com/65573069/226516679-206ad8f5-cb6b-4e87-a096-f4c595e09662.png)
![Screenshot (5)](https://user-images.githubusercontent.com/65573069/226516911-32c88022-10d6-43e7-9878-03147f0565a2.png)
![Screenshot (7)](https://user-images.githubusercontent.com/65573069/226517058-67c34aed-418b-46d7-b025-939988f2735c.png)

# Instructions for adding blocks
To add a block, follow these steps:
* Add block texture to texture atlas.
* Go to the blocks folder and create a file with the name of the block.
* #### File Format:
   * Line 1: Block id
   * Line 2: Block id of dropped block
* Go to items folder and create a new file with the name of the item.
* #### File Format:
   * Line 1: Item id
   * Line 2: Stack amount size
   * Line 3: Left click functionality
   * Line 4: Right clock functionality
   * (Optional) Line 5: Breaking speed
* Go to code, add texture coordinates of the block.
* Add an icon for the item of the block in the icons folder.
