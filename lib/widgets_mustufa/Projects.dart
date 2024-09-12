import 'package:flutter/material.dart';
import 'package:hiremi_version_two/Custom_Widget/CustomContainer/OutlinedButton.dart';
import 'package:hiremi_version_two/Custom_Widget/RoundedContainer/roundedContainer.dart';
import 'package:hiremi_version_two/Utils/AppSizes.dart';
import 'package:hiremi_version_two/Utils/colors.dart';
import 'package:hiremi_version_two/widgets_mustufa/AddProjects.dart';
import '../API_Integration/Add Projects/apiServices.dart';

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  _ProjectsState createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  List<Map<String, String>> projects = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final service = AddProjectDetailsService();
    try {
      final projectDetails = await service.getProjectDetails();
      setState(() {
        projects = [projectDetails];
      });
    } catch (error) {
      print('Failed to load projects: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedContainer(
      onEditTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddProjects()),
        );
        if (result == true) {
          // Refresh the project details if the result indicates success
          _loadProjects();
        }
      },
      title: 'Projects',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: projects.isEmpty
            ? [const Text('No projects available', style: TextStyle(fontSize: 12, color: Colors.grey))]
            : projects.map((project) {
          return ProjectsChild(
            title: project['project_title'] ?? '',
            duration: '${project['start_date'] ?? ''} - ${project['end_date'] ?? ''}',
            description: project['description'] ?? '',
            link: project['link'] ?? '',
          );
        }).toList(),
      ),
    );
  }
}

class ProjectsChild extends StatelessWidget {
  const ProjectsChild({
    Key? key,
    required this.title,
    required this.duration,
    required this.description,
    required this.link,
  }) : super(key: key);

  final String title, duration, description, link;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: const TextStyle(
              fontSize: 9.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: Sizes.responsiveXs(context)),
        ],
        // if (duration.isNotEmpty) ...[
        //   Text(
        //     duration,
        //     style: TextStyle(
        //       fontSize: 6.0,
        //       fontWeight: FontWeight.w500,
        //       color: AppColors.secondaryText,
        //     ),
        //   ),
        //   SizedBox(height: Sizes.responsiveSm(context)),
        // ],
        if (description.isNotEmpty) ...[
          Text(
            description,
            style: const TextStyle(
              fontSize: 9.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: Sizes.responsiveSm(context)),
        ],
        if (link.isNotEmpty) ...[
          RoundedContainer(
            color: Colors.blue[100],
            radius: 2,
            padding: EdgeInsets.all(Sizes.responsiveXs(context)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.attach_file, color: Colors.blue, size: 8),
                SizedBox(width: Sizes.responsiveXxs(context)),
                Text(
                  link,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                    fontWeight: FontWeight.w400,
                    fontSize: 8,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Sizes.responsiveSm(context)),
        ],
        Divider(
          height: 0.25,
          thickness: 0.25,
          color: AppColors.secondaryText,
        ),
      ],
    );
  }
}
