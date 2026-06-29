import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  SignUpRequested(this.email, this.password, this.fullName);
  @override
  List<Object> get props => [email, password, fullName];
}

class LogoutRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState {}
class Unauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(milliseconds: 1500));
      if (event.email.contains('@') && event.password.length >= 6) {
        emit(Authenticated());
      } else {
        emit(AuthError("Invalid email or password (min 6 chars)"));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(milliseconds: 1500));
      if (event.email.contains('@') && event.password.length >= 6 && event.fullName.isNotEmpty) {
        emit(Authenticated());
      } else {
        emit(AuthError("Please fill all fields and use a valid email/password"));
      }
    });

    on<LogoutRequested>((event, emit) {
      emit(Unauthenticated());
    });
  }
}

