import 'package:flutter/material.dart';
import 'package:unetpedia/ui/ui.dart';

class AppRouter {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (BuildContext contex) => const App(),

    // Authentication
    LoginView.routeName: (BuildContext contex) => const LoginView(),
    RegisterView.routeName: (BuildContext contex) => const RegisterView(),
    ForgotPasswordView.routeName: (BuildContext contex) =>
        const ForgotPasswordView(),

    // Home
    HomeView.routeName: (BuildContext contex) => const HomeView(),
    SettingsView.routeName: (context) => const SettingsView(),
    UpdatePasswordView.routeName: (context) => const UpdatePasswordView(),
    EditProfileView.routeName: (context) => const EditProfileView(),
    MyDocumentsView.routeName: (context) => const MyDocumentsView(),

    // Departments
    DepartmentsView.routeName: (BuildContext contex) => const DepartmentsView(),

    // Subjects
    SubjectsView.routeName: (BuildContext contex) => const SubjectsView(),
    SubjectDetailView.routeName: (BuildContext contex) =>
        const SubjectDetailView(),
    AddSubjectDocumentView.routeName: (context) =>
        const AddSubjectDocumentView(),
    SubjectDocumentView.routeName: (context) => const SubjectDocumentView(),

    // Qualification
    QualificationView.routeName: (context) => const QualificationView(),

    // Mentorship
    MentorshipsView.routeName: (context) => const MentorshipsView(),
    AddMentorshipView.routeName: (context) => const AddMentorshipView(),
    MentorshipDetailsView.routeName: (context) => const MentorshipDetailsView(),
  };
}
