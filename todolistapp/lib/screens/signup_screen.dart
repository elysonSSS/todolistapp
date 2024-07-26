import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todolistapp/screens/home_screen.dart';
import 'package:todolistapp/screens/login_screen.dart';
import 'package:todolistapp/services/auth_services.dart';

class SignupScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630),
      appBar: AppBar(
        backgroundColor: Color(0xFF1d2630),
        foregroundColor: Colors.white,
        title: Text("Lista de tarefas"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 50),
              Text("Bem-vindo(a)",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              ),
              SizedBox(height: 5),
              Text("Registre-se aqui",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              ),
              SizedBox(height: 40),
              TextField( 
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white60)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                    labelText: "E-mail",
                    labelStyle: TextStyle(color: Colors.white60),
                  ),
                ),
              SizedBox(height: 20),
              TextField( 
                controller: _passController,
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration:  InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white60)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                    labelText: "Senha",
                    labelStyle: TextStyle(color: Colors.white60),
                  ),
                ),
                SizedBox(height: 50),
                SizedBox(height: 50,
                width: MediaQuery.of(context).size.width/1.5, child:
                ElevatedButton(onPressed: ()async{
                  User? user = await _auth.registerWithEmailAndPassword(
                    _emailController.text,
                    _passController.text,
                  );
                  
                  if(user!=null){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(),));
                  }
                }, 
                child: Text(
                  "Cadastrar",
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 18,
                ),
                )),
                ),
                SizedBox(height: 20),
                Text("Já tem conta?", style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                  }, child: Text("Entrar", style: TextStyle(fontSize: 18),))
                
            ],
            ),    
          ) ,
        ),
    );

  }
}