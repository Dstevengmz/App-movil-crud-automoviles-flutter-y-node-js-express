import 'package:flutter/material.dart';
import '../services/apiservicio.dart';
import '../services/session_manager.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final u = SessionManager.currentUser;
    _nameCtrl.text = u?.name ?? '';
    _emailCtrl.text = u?.email ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final user = SessionManager.currentUser;
    if (user == null) return;
    setState(() => _saving = true);
    try {
      await ApiService.updateUser(
        id: user.id,
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password:
            _passwordCtrl.text.trim().isEmpty
                ? null
                : _passwordCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Ingrese un nombre'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Ingrese un email'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nueva contraseña (opcional)',
                ),
                obscureText: true,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _guardar,
                  icon:
                      _saving
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.save),
                  label: Text(_saving ? 'Guardando...' : 'Guardar cambios'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
