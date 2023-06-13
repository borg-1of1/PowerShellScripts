import string

text = (input("Enter a message: "))
shift = int(input("Enter the distance: "))

alphabet = string.printable
shifted = alphabet[shift:] + alphabet[:shift]

table = str.maketrans(alphabet, shifted)

encrypted = text.translate(table)

print(encrypted)