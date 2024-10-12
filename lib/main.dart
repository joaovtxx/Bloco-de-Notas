import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Classe principal do aplicativo.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloco de Notas', // Título do aplicativo
      theme: ThemeData(
        primarySwatch: Colors.blue, // Cor primária do tema
      ),
      home: ChecklistNotepad(), // Tela inicial
    );
  }
}

// Tela de checklist do bloco de notas
class ChecklistNotepad extends StatefulWidget {
  @override
  _ChecklistNotepadState createState() => _ChecklistNotepadState();
}

class _ChecklistNotepadState extends State<ChecklistNotepad> {
  // Lista de tarefas
  final List<Map<String, dynamic>> _tasks = [];
  // Controlador para o campo de texto
  final TextEditingController _controller = TextEditingController();

  // Adiciona uma nova tarefa à lista
  void _addTask(String title) {
    setState(() {
      _tasks.add({'title': title, 'completed': false});
    });
    _controller.clear(); // Limpa o campo de texto após adicionar a tarefa
  }

  // Alterna o status de conclusão da tarefa
  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
      _reorderTasks(); // Reorganiza as tarefas após a alteração
    });
  }

  // Reorganiza as tarefas, colocando as não concluídas primeiro
  void _reorderTasks() {
    List<Map<String, dynamic>> pendingTasks =
        _tasks.where((task) => !task['completed']).toList();
    List<Map<String, dynamic>> completedTasks =
        _tasks.where((task) => task['completed']).toList();

    setState(() {
      _tasks
        ..clear()
        ..addAll(pendingTasks)
        ..addAll(completedTasks);
    });
  }

  // Remove uma tarefa da lista
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Cor da barra de navegação
        title: Text(
          'To do List', // Título da aplicação
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Campo de texto para adicionar nova tarefa
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Tarefa', // Texto de sugestão
                    prefixIcon: Icon(
                      Icons.book, // Ícone de livro no campo de texto
                      color: Colors.grey, // Cor cinza para o ícone
                    ),
                    contentPadding:
                        EdgeInsets.only(left: 10), // Espaçamento interno
                    border: OutlineInputBorder(), // Borda do campo de texto
                  ),
                ),
                SizedBox(height: 10), // Espaço entre o campo de texto e o botão
                // Botão para cadastrar a tarefa
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _addTask(_controller
                          .text); // Adiciona a tarefa se o campo não estiver vazio
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Cor de fundo do botão
                    foregroundColor: Colors.white, // Cor do texto do botão
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(4.0), // Borda menos arredondada
                    ),
                  ),
                  child: Text('Cadastrar'), // Texto do botão
                ),
              ],
            ),
          ),
          // Lista de tarefas
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index]; // Tarefa atual
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          task['title'],
                          style: TextStyle(
                            decoration: task['completed']
                                ? TextDecoration.lineThrough // Tarefa concluída
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      Checkbox(
                        value:
                            task['completed'], // Status de conclusão da tarefa
                        onChanged: (value) {
                          _toggleTaskCompletion(
                              index); // Alterna o status ao clicar
                        },
                        activeColor: Colors.green, // Cor verde quando marcado
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete), // Ícone de deletar
                    onPressed: () =>
                        _deleteTask(index), // Remove a tarefa ao clicar
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
