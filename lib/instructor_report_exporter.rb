require 'csv'

class InstructorReportExporter
  include ApplicationHelper
  include InstructorHelper

  HEADINGS = [
    "Undergraduate and Graduate Courses Taught",
    "Semester",
    "No. of Students Enrolled",
    "No. of Responses",
    "Mean Student Evaluation Score",
    "Avg. Numerical Grade Earned by Students",
    "Avg. Course Level Numerical Grade",
    "Dept Avg Student Evaluation Score for Equivalent Level Courses"
  ]

  def initialize(instructor, evaluation_groups)
    @instructor = instructor
    @course_groups = @instructor.course_section_groups.sort { |group1, group2| group2.first.term <=> group1.first.term }
    @evaluation_groups = evaluation_groups
  end

  def generate
    CSV.generate do |csv|
      csv << [ @instructor.name ]
      csv << []
      csv << HEADINGS
      @course_groups.each do |courses|
        course_data = []
        course_data.push(get_complete_name(courses))
        course_data.push(term_format(courses.first.term))
        course_data.push(compute_total_enrollment(courses))
        course_data.push(compute_total_responses(courses))
        course_data.push(compute_mean_student_eval_score(courses).round(2))
        course_data.push(compute_mean_gpr(courses))
        course_data.push(compute_course_level_mean_gpr(courses, @evaluation_groups).try(:round, 2))
        course_data.push(compute_course_level_average(courses,@evaluation_groups).round(2))
        csv << course_data
      end
    end
  end
end
