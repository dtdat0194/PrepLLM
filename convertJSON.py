import json
import re
from pathlib import Path

def convert_difficulty(letter):
    """Convert letter-based difficulty to numeric scale."""
    mapping = {"E": 1, "M": 2, "H": 3}
    return mapping.get(letter.upper(), 2)

def convert_type(q_type):
    """Convert SAT type to simplified type."""
    return "grid-in" if q_type == "spr" else "multiple-choice"

def strip_html(html_text):
    """Strip HTML tags from answer content."""
    return re.sub("<.*?>", "", html_text).strip()

def transform_questions(input_file, output_file):
    # Load original JSON
    with open(input_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    transformed = []

    for q_id, q_data in data.items():
        content = q_data.get("content", {})
        correct_answers = content.get("correct_answer", [])

        # Strip HTML from choices if present
        raw_choices = content.get("answerOptions")
        if raw_choices:
            cleaned_choices = [strip_html(choice["content"]) for choice in raw_choices if "content" in choice]
        else:
            cleaned_choices = None

        transformed.append({
            "id": q_id,
            "program": q_data.get("program", "SAT"),
            "section": "Math" if q_data.get("module") == "math" else "Reading and Writing",
            "domain": q_data.get("primary_class_cd_desc", ""),
            "skill": q_data.get("skill_desc", ""),
            "difficulty": convert_difficulty(q_data.get("difficulty", "M")),
            "type": convert_type(content.get("type", "mcq")),
            "visuals": {
                "type": None,
                "svg_content": None
            },
            "question": {
                "paragraph": None,
                "question": content.get("stem", ""),
                "choices": cleaned_choices,
                "correct_answer": correct_answers,
                "explanation": content.get("rationale", None)
            },
            "image_url": None
        })

    # Write to output file
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(transformed, f, indent=2)

    print(f"✅ Transformed {len(transformed)} questions saved to {output_file}")


# === Run this ===
if __name__ == "__main__":
    input_path = "cb-digital-questions.json"
    output_path = "cleaned_questions_full.json"
    transform_questions(input_path, output_path)
