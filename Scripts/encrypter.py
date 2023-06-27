import string

# input - string to be either encrypted or decrypted, the shift, and whether to encrypt or decrypt
text = (input("Enter a message: "))
shift = int(input("Enter the distance: "))
reverse = (input("Decrypt the sstring (y/n)? "))

# Build character set that covers all characters including digits and punctuation
character_set = string.ascii_letters + ' !"#$%&' + "'" + '()*+-}/:;<=>?@[\]^_`{,|.~' + string.digits
#string.ascii_letters + " " + string.punctuation + string.digits

# define funtion for andling encrpytion with plain text, shift, and character set as inputs
def cipher_encrypt(plain_text, key, characters, decrypt=False):
    if key < 0:
        print("Key cannot be negative")
        return None
    n = len(characters)
    if decrypt==True:
        key = n - key
    table = str.maketrans(characters,characters[key:]+characters[:key])
    translated_text = text.translate(table)
    return translated_text

#def cipher_decrypt(ciphertext, key, characters):
#    decrypted = ""
#    for c in ciphertext:
#        c_index = ord(c) - ord ('A')
#        n = len(characters)
#        c_og_pos = (c_index - key) % n + ord('A')
#        c_og = chr(c_og_pos)
#        decrypted += c_og
#    return decrypted


def decrypt_message(text,shift,character_set):
    decrypted_message =""
    for ch in text:
        if ch in character_set:
            position = character_set.find(ch)
            new_pos = (position - shift) % (len(character_set))
            new_char = character_set[new_pos]
            decrypted_message += new_char
        else:
            decrypted_message += ch
    return decrypted_message

if reverse=="y":
    decrypt=True
else:
    decrypt=False
encrypted = cipher_encrypt(text,shift,character_set,decrypt)
decrypted_message = decrypt_message(text,shift,character_set)
print(encrypted)    

print('\n')

print(decrypted_message)