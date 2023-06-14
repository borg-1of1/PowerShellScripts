import string

text = (input("Enter a message: "))
shift = int(input("Enter the distance: "))

#alphabet = string.printable
#shifted = alphabet[shift:] + alphabet[:shift]

#table = str.maketrans(alphabet, shifted)

#encrypted = text.translate(table)

#print(encrypted)

# Build character set that covers all characters including digits and punctuation
character_set = string.ascii_lowercase + string.ascii_uppercase + string.digits + " " + string.punctuation

# define funtion for andling encrpytion with plain text, shift, and character set as inputs
def cipher_encrypt(plain_text, key, characters):
    if key < 0:
        print("Key cannot be negative")
        return None
    n = len(characters)

    table = str.maketrans(characters,characters[key:]+characters[:key])
    translated_text = text.translate(table)
    return translated_text

encrypted = cipher_encrypt(text,shift,character_set)
print(encrypted)    