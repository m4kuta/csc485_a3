import os

parent_dir = os.path.dirname(os.path.abspath(__file__))

# Open the input file for reading
with open(f"{parent_dir}/input.txt", "r") as input_file:
  # Open the output file for writing
  with open(f"{parent_dir}/output.txt", "w") as output_file:
    # Read each line from the input file
    for line in input_file:
      line = line.strip()
      
      if not line:
        output_file.write("\n")
      else:
        # Split the line into words using whitespace as the delimiter
        words = line.split()

        # Write the array of words to the output file
        output_file.write("rec(" + str(words) + ").\n")
