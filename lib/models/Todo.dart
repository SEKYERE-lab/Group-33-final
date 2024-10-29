/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously


/** This is an auto generated class representing the Todo type in your schema. */
class Todo {
  final String id;
  final String? name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

   // Constructor
  Todo({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

   // Factory method to create a Todo instance from JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Method to convert a Todo instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Equality operator to compare two Todo instances
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Todo &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  // HashCode method to generate a hash code for the Todo instance
  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ (description?.hashCode ?? 0) ^ (createdAt?.hashCode ?? 0) ^ (updatedAt?.hashCode ?? 0);

  // toString method to get a string representation of the Todo instance
  @override
  String toString() {
    return 'Todo{id: $id, name: $name, description: $description, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  // Method to create a copy of the current Todo instance with modified values
  Todo copyWith({
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}