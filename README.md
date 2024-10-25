Simulated Ant Controller Evolution with Genetic Algorithms (from Scratch)
This project involves implementing a genetic algorithm from scratch in MATLAB to evolve an intelligent controller for a simulated ant. 
The ant navigates a complex 32x32 grid (John Muir trail), containing food-laden cells. 
The ant receives binary sensory input (food detection) and performs one of four actions: move forward, turn left, turn right, or do nothing.

The task is to evolve better-performing ants over generations using crossover and mutation operators, without using MATLAB's built-in "ga" function. 
The fitness of each ant is based on its ability to find and consume food, leading to evolved survival strategies.

The final accuracy was tested as the mean of the procentage of food cells reached in 200 time-steps out of 10 tries. 
The average accuracy reached in aprox. 91%.
![Screenshot 2024-10-25 at 13 40 34](https://github.com/user-attachments/assets/a49ca1ef-67a7-4f26-aa55-aa9fc9a7d984)
![Screenshot 2024-10-25 at 13 40 54](https://github.com/user-attachments/assets/90c16af7-a85a-48b0-ba67-3d15b16f5d20)
