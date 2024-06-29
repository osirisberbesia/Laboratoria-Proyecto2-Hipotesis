import re

def generate_index(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    headers = []
    for line in lines:
        if line.startswith('#'):
            headers.append(line.strip())

    index = []
    for header in headers:
        level = header.count('#')
        title = header.strip('#').strip()
        anchor = re.sub(r'[^a-zA-Z0-9 ]', '', title).replace(' ', '-').lower()
        index.append(f'{"  " * (level - 1)}- [{title}](#{anchor})')

    with open(file_path, 'w', encoding='utf-8') as file:
        file.write('# Índice\n\n')
        file.write('\n'.join(index) + '\n\n')
        file.writelines(lines)

# Ruta al archivo Markdown
file_path = r'C:\Users\Oberb\OneDrive\Documentos\README.md'
generate_index(file_path)
