import os
from openai import OpenAI

# ==========================================
# 🛑 STEP 1: PASTE YOUR KEY HERE
# ==========================================
API_KEY = "YOUR_OPENAI_API_KEY"

# Configuration
OUTPUT_FOLDER = "assets/audio/questions"
client = OpenAI(api_key=API_KEY)

# ==========================================
# 📚 DATABASE: ALL QUESTIONS (2008 + 2025)
# ==========================================
questions_db = [
    # --- 2008 VERSION (100 Questions) ---
    {"id": "1", "ver": "2008", "text": "What is the supreme law of the land?"},
    {"id": "2", "ver": "2008", "text": "What does the Constitution do?"},
    {"id": "3", "ver": "2008", "text": "The idea of self-government is in the first three words of the Constitution. What are these words?"},
    {"id": "4", "ver": "2008", "text": "What is an amendment?"},
    {"id": "5", "ver": "2008", "text": "What do we call the first ten amendments to the Constitution?"},
    {"id": "6", "ver": "2008", "text": "What is one right or freedom from the First Amendment?"},
    {"id": "7", "ver": "2008", "text": "How many amendments does the Constitution have?"},
    {"id": "8", "ver": "2008", "text": "What did the Declaration of Independence do?"},
    {"id": "9", "ver": "2008", "text": "What are two rights in the Declaration of Independence?"},
    {"id": "10", "ver": "2008", "text": "What is freedom of religion?"},
    {"id": "11", "ver": "2008", "text": "What is the economic system in the United States?"},
    {"id": "12", "ver": "2008", "text": "What is the rule of law?"},
    {"id": "13", "ver": "2008", "text": "Name one branch or part of the government."},
    {"id": "14", "ver": "2008", "text": "What stops one branch of government from becoming too powerful?"},
    {"id": "15", "ver": "2008", "text": "Who is in charge of the executive branch?"},
    {"id": "16", "ver": "2008", "text": "Who makes federal laws?"},
    {"id": "17", "ver": "2008", "text": "What are the two parts of the U.S. Congress?"},
    {"id": "18", "ver": "2008", "text": "How many U.S. Senators are there?"},
    {"id": "19", "ver": "2008", "text": "We elect a U.S. Senator for how many years?"},
    {"id": "20", "ver": "2008", "text": "Who is one of your state's U.S. Senators now?"},
    {"id": "21", "ver": "2008", "text": "The House of Representatives has how many voting members?"},
    {"id": "22", "ver": "2008", "text": "We elect a U.S. Representative for how many years?"},
    {"id": "23", "ver": "2008", "text": "Name your U.S. Representative."},
    {"id": "24", "ver": "2008", "text": "Who does a U.S. Senator represent?"},
    {"id": "25", "ver": "2008", "text": "Why do some states have more Representatives than other states?"},
    {"id": "26", "ver": "2008", "text": "We elect a President for how many years?"},
    {"id": "27", "ver": "2008", "text": "In what month do we vote for President?"},
    {"id": "28", "ver": "2008", "text": "What is the name of the President of the United States now?"},
    {"id": "29", "ver": "2008", "text": "What is the name of the Vice President of the United States now?"},
    {"id": "30", "ver": "2008", "text": "If the President can no longer serve, who becomes President?"},
    {"id": "31", "ver": "2008", "text": "If both the President and the Vice President can no longer serve, who becomes President?"},
    {"id": "32", "ver": "2008", "text": "Who is the Commander in Chief of the military?"},
    {"id": "33", "ver": "2008", "text": "Who signs bills to become laws?"},
    {"id": "34", "ver": "2008", "text": "Who vetoes bills?"},
    {"id": "35", "ver": "2008", "text": "What does the President's Cabinet do?"},
    {"id": "36", "ver": "2008", "text": "What are two Cabinet-level positions?"},
    {"id": "37", "ver": "2008", "text": "What does the judicial branch do?"},
    {"id": "38", "ver": "2008", "text": "What is the highest court in the United States?"},
    {"id": "39", "ver": "2008", "text": "How many justices are on the Supreme Court?"},
    {"id": "40", "ver": "2008", "text": "Who is the Chief Justice of the United States now?"},
    {"id": "41", "ver": "2008", "text": "Under our Constitution, some powers belong to the federal government. What is one power of the federal government?"},
    {"id": "42", "ver": "2008", "text": "Under our Constitution, some powers belong to the states. What is one power of the states?"},
    {"id": "43", "ver": "2008", "text": "Who is the Governor of your state now?"},
    {"id": "44", "ver": "2008", "text": "What is the capital of your state?"},
    {"id": "45", "ver": "2008", "text": "What are the two major political parties in the United States?"},
    {"id": "46", "ver": "2008", "text": "What is the political party of the President now?"},
    {"id": "47", "ver": "2008", "text": "What is the name of the Speaker of the House of Representatives now?"},
    {"id": "48", "ver": "2008", "text": "There are four amendments to the Constitution about who can vote. Describe one of them."},
    {"id": "49", "ver": "2008", "text": "What is one responsibility that is only for United States citizens?"},
    {"id": "50", "ver": "2008", "text": "Name one right only for United States citizens."},
    {"id": "51", "ver": "2008", "text": "What are two rights of everyone living in the United States?"},
    {"id": "52", "ver": "2008", "text": "What do we show loyalty to when we say the Pledge of Allegiance?"},
    {"id": "53", "ver": "2008", "text": "What is one promise you make when you become a United States citizen?"},
    {"id": "54", "ver": "2008", "text": "How old do citizens have to be to vote for President?"},
    {"id": "55", "ver": "2008", "text": "What are two ways that Americans can participate in their democracy?"},
    {"id": "56", "ver": "2008", "text": "When is the last day you can send in federal income tax forms?"},
    {"id": "57", "ver": "2008", "text": "When must all men register for the Selective Service?"},
    {"id": "58", "ver": "2008", "text": "What is one reason colonists came to America?"},
    {"id": "59", "ver": "2008", "text": "Who lived in America before the Europeans arrived?"},
    {"id": "60", "ver": "2008", "text": "What group of people was taken to America and sold as slaves?"},
    {"id": "61", "ver": "2008", "text": "Why did the colonists fight the British?"},
    {"id": "62", "ver": "2008", "text": "Who wrote the Declaration of Independence?"},
    {"id": "63", "ver": "2008", "text": "When was the Declaration of Independence adopted?"},
    {"id": "64", "ver": "2008", "text": "There were 13 original states. Name three."},
    {"id": "65", "ver": "2008", "text": "What happened at the Constitutional Convention?"},
    {"id": "66", "ver": "2008", "text": "When was the Constitution written?"},
    {"id": "67", "ver": "2008", "text": "The Federalist Papers supported the passage of the U.S. Constitution. Name one of the writers."},
    {"id": "68", "ver": "2008", "text": "What is one thing Benjamin Franklin is famous for?"},
    {"id": "69", "ver": "2008", "text": "Who is the Father of Our Country?"},
    {"id": "70", "ver": "2008", "text": "Who was the first President?"},
    {"id": "71", "ver": "2008", "text": "What territory did the United States buy from France in 1803?"},
    {"id": "72", "ver": "2008", "text": "Name one war fought by the United States in the 1800s."},
    {"id": "73", "ver": "2008", "text": "Name the U.S. war between the North and the South."},
    {"id": "74", "ver": "2008", "text": "Name one problem that led to the Civil War."},
    {"id": "75", "ver": "2008", "text": "What was one important thing that Abraham Lincoln did?"},
    {"id": "76", "ver": "2008", "text": "What did the Emancipation Proclamation do?"},
    {"id": "77", "ver": "2008", "text": "What did Susan B. Anthony do?"},
    {"id": "78", "ver": "2008", "text": "Name one war fought by the United States in the 1900s."},
    {"id": "79", "ver": "2008", "text": "Who was President during World War I?"},
    {"id": "80", "ver": "2008", "text": "Who was President during the Great Depression and World War II?"},
    {"id": "81", "ver": "2008", "text": "Who did the United States fight in World War II?"},
    {"id": "82", "ver": "2008", "text": "Before he was President, Eisenhower was a general. What war was he in?"},
    {"id": "83", "ver": "2008", "text": "During the Cold War, what was the main concern of the United States?"},
    {"id": "84", "ver": "2008", "text": "What movement tried to end racial discrimination?"},
    {"id": "85", "ver": "2008", "text": "What did Martin Luther King, Jr. do?"},
    {"id": "86", "ver": "2008", "text": "What major event happened on September 11, 2001, in the United States?"},
    {"id": "87", "ver": "2008", "text": "Name one American Indian tribe in the United States."},
    {"id": "88", "ver": "2008", "text": "Name one of the two longest rivers in the United States."},
    {"id": "89", "ver": "2008", "text": "What ocean is on the West Coast of the United States?"},
    {"id": "90", "ver": "2008", "text": "What ocean is on the East Coast of the United States?"},
    {"id": "91", "ver": "2008", "text": "Name one U.S. territory."},
    {"id": "92", "ver": "2008", "text": "Name one state that borders Canada."},
    {"id": "93", "ver": "2008", "text": "Name one state that borders Mexico."},
    {"id": "94", "ver": "2008", "text": "What is the capital of the United States?"},
    {"id": "95", "ver": "2008", "text": "Where is the Statue of Liberty?"},
    {"id": "96", "ver": "2008", "text": "Why does the flag have 13 stripes?"},
    {"id": "97", "ver": "2008", "text": "Why does the flag have 50 stars?"},
    {"id": "98", "ver": "2008", "text": "What is the name of the national anthem?"},
    {"id": "99", "ver": "2008", "text": "When do we celebrate Independence Day?"},
    {"id": "100", "ver": "2008", "text": "Name two national U.S. holidays."},
    {"id": "1", "ver": "2025", "text": "What is the form of government of the United States?"},
    {"id": "2", "ver": "2025", "text": "What is the supreme law of the land?"},
    {"id": "3", "ver": "2025", "text": "Name one thing the U.S. Constitution does."},
    {"id": "4", "ver": "2025", "text": "The U.S. Constitution starts with the words 'We the People.' What does 'We the People' mean?"},
    {"id": "5", "ver": "2025", "text": "How are changes made to the U.S. Constitution?"},
    {"id": "6", "ver": "2025", "text": "What does the Bill of Rights protect?"},
    {"id": "7", "ver": "2025", "text": "How many amendments does the U.S. Constitution have?"},
    {"id": "8", "ver": "2025", "text": "Why is the Declaration of Independence important?"},
    {"id": "9", "ver": "2025", "text": "What founding document said the American colonies were free from Britain?"},
    {"id": "10", "ver": "2025", "text": "Name two important ideas from the Declaration of Independence and the U.S. Constitution."},
    {"id": "11", "ver": "2025", "text": "The words 'Life, Liberty, and the pursuit of Happiness' are in what founding document?"},
    {"id": "12", "ver": "2025", "text": "What is the economic system of the United States?"},
    {"id": "13", "ver": "2025", "text": "What is the rule of law?"},
    {"id": "14", "ver": "2025", "text": "Many documents influenced the U.S. Constitution. Name one."},
    {"id": "15", "ver": "2025", "text": "There are three branches of government. Why?"},
    {"id": "16", "ver": "2025", "text": "Name the three branches of government."},
    {"id": "17", "ver": "2025", "text": "The President of the United States is in charge of which branch of government?"},
    {"id": "18", "ver": "2025", "text": "What part of the federal government writes laws?"},
    {"id": "19", "ver": "2025", "text": "What are the two parts of the U.S. Congress?"},
    {"id": "20", "ver": "2025", "text": "Name one power of the U.S. Congress."},
    {"id": "21", "ver": "2025", "text": "How many U.S. senators are there?"},
    {"id": "22", "ver": "2025", "text": "How long is a term for a U.S. senator?"},
    {"id": "23", "ver": "2025", "text": "Who is one of your state's U.S. senators now?"},
    {"id": "24", "ver": "2025", "text": "How many voting members are in the House of Representatives?"},
    {"id": "25", "ver": "2025", "text": "How long is a term for a member of the House of Representatives?"},
    {"id": "26", "ver": "2025", "text": "Why do U.S. representatives serve shorter terms than U.S. senators?"},
    {"id": "27", "ver": "2025", "text": "How many senators does each state have?"},
    {"id": "28", "ver": "2025", "text": "Why does each state have two senators?"},
    {"id": "29", "ver": "2025", "text": "Name your U.S. Representative."},
    {"id": "30", "ver": "2025", "text": "What is the name of the Speaker of the House of Representatives now?"},
    {"id": "31", "ver": "2025", "text": "Who does a U.S. senator represent?"},
    {"id": "32", "ver": "2025", "text": "Who elects U.S. senators?"},
    {"id": "33", "ver": "2025", "text": "Who does a member of the House of Representatives represent?"},
    {"id": "34", "ver": "2025", "text": "Who elects members of the House of Representatives?"},
    {"id": "35", "ver": "2025", "text": "Some states have more representatives than other states. Why?"},
    {"id": "36", "ver": "2025", "text": "The President of the United States is elected for how many years?"},
    {"id": "37", "ver": "2025", "text": "The President of the United States can serve only two terms. Why?"},
    {"id": "38", "ver": "2025", "text": "What is the name of the President of the United States now?"},
    {"id": "39", "ver": "2025", "text": "What is the name of the Vice President of the United States now?"},
    {"id": "40", "ver": "2025", "text": "If the President can no longer serve, who becomes President?"},
    {"id": "41", "ver": "2025", "text": "Name one power of the President."},
    {"id": "42", "ver": "2025", "text": "Who is Commander in Chief of the U.S. military?"},
    {"id": "43", "ver": "2025", "text": "Who signs bills to become laws?"},
    {"id": "44", "ver": "2025", "text": "Who vetoes bills?"},
    {"id": "45", "ver": "2025", "text": "Who appoints federal judges?"},
    {"id": "46", "ver": "2025", "text": "The executive branch has many parts. Name one."},
    {"id": "47", "ver": "2025", "text": "What does the President's Cabinet do?"},
    {"id": "48", "ver": "2025", "text": "What are two Cabinet-level positions?"},
    {"id": "49", "ver": "2025", "text": "Why is the Electoral College important?"},
    {"id": "50", "ver": "2025", "text": "What is one part of the judicial branch?"},
    {"id": "51", "ver": "2025", "text": "What does the judicial branch do?"},
    {"id": "52", "ver": "2025", "text": "What is the highest court in the United States?"},
    {"id": "53", "ver": "2025", "text": "How many seats are on the Supreme Court?"},
    {"id": "54", "ver": "2025", "text": "How many Supreme Court justices are usually needed to decide a case?"},
    {"id": "55", "ver": "2025", "text": "How long do Supreme Court justices serve?"},
    {"id": "56", "ver": "2025", "text": "Supreme Court justices serve for life. Why?"},
    {"id": "57", "ver": "2025", "text": "Who is the Chief Justice of the United States now?"},
    {"id": "58", "ver": "2025", "text": "Name one power that is only for the federal government."},
    {"id": "59", "ver": "2025", "text": "Name one power that is only for the states."},
    {"id": "60", "ver": "2025", "text": "What is the purpose of the 10th Amendment?"},
    {"id": "61", "ver": "2025", "text": "Who is the Governor of your state now?"},
    {"id": "62", "ver": "2025", "text": "What is the capital of your state?"},
    {"id": "63", "ver": "2025", "text": "There are four amendments to the U.S. Constitution about who can vote. Describe one of them."},
    {"id": "64", "ver": "2025", "text": "Who can vote in federal elections, run for federal office, and serve on a jury in the United States?"},
    {"id": "65", "ver": "2025", "text": "What are three rights of everyone living in the United States?"},
    {"id": "66", "ver": "2025", "text": "What do we show loyalty to when we say the Pledge of Allegiance?"},
    {"id": "67", "ver": "2025", "text": "Name two promises that new citizens make in the Oath of Allegiance."},
    {"id": "68", "ver": "2025", "text": "How can people become United States citizens?"},
    {"id": "69", "ver": "2025", "text": "What are two examples of civic participation in the United States?"},
    {"id": "70", "ver": "2025", "text": "What is one way Americans can serve their country?"},
    {"id": "71", "ver": "2025", "text": "Why is it important to pay federal taxes?"},
    {"id": "72", "ver": "2025", "text": "It is important for all men age 18 through 25 to register for the Selective Service. Name one reason why."},
    {"id": "73", "ver": "2025", "text": "The colonists came to America for many reasons. Name one."},
    {"id": "74", "ver": "2025", "text": "Who lived in America before the Europeans arrived?"},
    {"id": "75", "ver": "2025", "text": "What group of people was taken to America and sold as slaves?"},
    {"id": "76", "ver": "2025", "text": "What war did the Americans fight to win independence from Britain?"},
    {"id": "77", "ver": "2025", "text": "Name one reason why the Americans declared independence from Britain."},
    {"id": "78", "ver": "2025", "text": "Who wrote the Declaration of Independence?"},
    {"id": "79", "ver": "2025", "text": "When was the Declaration of Independence adopted?"},
    {"id": "80", "ver": "2025", "text": "The American Revolution had many important events. Name one."},
    {"id": "81", "ver": "2025", "text": "There were 13 original states. Name five."},
    {"id": "82", "ver": "2025", "text": "What founding document was written in 1787?"},
    {"id": "83", "ver": "2025", "text": "The Federalist Papers supported the passage of the U.S. Constitution. Name one of the writers."},
    {"id": "84", "ver": "2025", "text": "Why were the Federalist Papers important?"},
    {"id": "85", "ver": "2025", "text": "Benjamin Franklin is famous for many things. Name one."},
    {"id": "86", "ver": "2025", "text": "George Washington is famous for many things. Name one."},
    {"id": "87", "ver": "2025", "text": "Thomas Jefferson is famous for many things. Name one."},
    {"id": "88", "ver": "2025", "text": "James Madison is famous for many things. Name one."},
    {"id": "89", "ver": "2025", "text": "Alexander Hamilton is famous for many things. Name one."},
    {"id": "90", "ver": "2025", "text": "What territory did the United States buy from France in 1803?"},
    {"id": "91", "ver": "2025", "text": "Name one war fought by the United States in the 1800s."},
    {"id": "92", "ver": "2025", "text": "Name the U.S. war between the North and the South."},
    {"id": "93", "ver": "2025", "text": "The Civil War had many important events. Name one."},
    {"id": "94", "ver": "2025", "text": "Abraham Lincoln is famous for many things. Name one."},
    {"id": "95", "ver": "2025", "text": "What did the Emancipation Proclamation do?"},
    {"id": "96", "ver": "2025", "text": "What U.S. war ended slavery?"},
    {"id": "97", "ver": "2025", "text": "What amendment gives citizenship to all persons born in the United States?"},
    {"id": "98", "ver": "2025", "text": "When did all men get the right to vote?"},
    {"id": "99", "ver": "2025", "text": "Name one leader of the women's rights movement in the 1800s."},
    {"id": "100", "ver": "2025", "text": "Name one war fought by the United States in the 1900s."},
    {"id": "101", "ver": "2025", "text": "Why did the United States enter World War I?"},
    {"id": "102", "ver": "2025", "text": "When did all women get the right to vote?"},
    {"id": "103", "ver": "2025", "text": "What was the Great Depression?"},
    {"id": "104", "ver": "2025", "text": "When did the Great Depression start?"},
    {"id": "105", "ver": "2025", "text": "Who was President during the Great Depression and World War II?"},
    {"id": "106", "ver": "2025", "text": "Why did the United States enter World War II?"},
    {"id": "107", "ver": "2025", "text": "Dwight Eisenhower is famous for many things. Name one."},
    {"id": "108", "ver": "2025", "text": "Who was the United States' main rival during the Cold War?"},
    {"id": "109", "ver": "2025", "text": "During the Cold War, what was one main concern of the United States?"},
    {"id": "110", "ver": "2025", "text": "Why did the United States enter the Korean War?"},
    {"id": "111", "ver": "2025", "text": "Why did the United States enter the Vietnam War?"},
    {"id": "112", "ver": "2025", "text": "What did the civil rights movement do?"},
    {"id": "113", "ver": "2025", "text": "Martin Luther King, Jr. is famous for many things. Name one."},
    {"id": "114", "ver": "2025", "text": "Why did the United States enter the Persian Gulf War?"},
    {"id": "115", "ver": "2025", "text": "What major event happened on September 11, 2001, in the United States?"},
    {"id": "116", "ver": "2025", "text": "Name one U.S. military conflict after the September 11, 2001 attacks."},
    {"id": "117", "ver": "2025", "text": "Name one American Indian tribe in the United States."},
    {"id": "118", "ver": "2025", "text": "Name one example of an American innovation."},
    {"id": "119", "ver": "2025", "text": "What is the capital of the United States?"},
    {"id": "120", "ver": "2025", "text": "Where is the Statue of Liberty?"},
    {"id": "121", "ver": "2025", "text": "Why does the flag have 13 stripes?"},
    {"id": "122", "ver": "2025", "text": "Why does the flag have 50 stars?"},
    {"id": "123", "ver": "2025", "text": "What is the name of the national anthem?"},
    {"id": "124", "ver": "2025", "text": "The Nation's first motto was 'E Pluribus Unum.' What does that mean?"},
    {"id": "125", "ver": "2025", "text": "What is Independence Day?"},
    {"id": "126", "ver": "2025", "text": "Name three national U.S. holidays."},
    {"id": "127", "ver": "2025", "text": "What is Memorial Day?"},
    {"id": "128", "ver": "2025", "text": "What is Veterans Day?"}
]

def generate_audio():
    if not os.path.exists(OUTPUT_FOLDER):
        os.makedirs(OUTPUT_FOLDER)
        print(f"Created folder: {OUTPUT_FOLDER}")

    # --- 1. GENERATE QUESTIONS ---
    print(f"\n🎧 Generating {len(questions_db)} Questions...")
    for q in questions_db:
        filename = f"q_{q['ver']}_{q['id']}.mp3"
        filepath = os.path.join(OUTPUT_FOLDER, filename)
        
        if os.path.exists(filepath):
            continue # Skip existing

        print(f"Generating Question: {filename}...")
        try:
            response = client.audio.speech.create(
                model="tts-1",
                voice="onyx", # DEEP, SERIOUS VOICE
                input=q['text']
            )
            response.stream_to_file(filepath)
        except Exception as e:
            print(f"FAILED on {filename}: {e}")

    # --- 2. GENERATE ANSWERS ---
    print(f"\n✅ Generating {len(answers_db)} Answers...")
    for a in answers_db:
        filename = f"a_{a['ver']}_{a['id']}.mp3"
        filepath = os.path.join(OUTPUT_FOLDER, filename)
        
        if os.path.exists(filepath):
            continue # Skip existing

        print(f"Generating Answer: {filename}...")
        try:
            response = client.audio.speech.create(
                model="tts-1",
                voice="shimmer", # FEMALE, CLEAR VOICE
                input=a['text']
            )
            response.stream_to_file(filepath)
        except Exception as e:
            print(f"FAILED on {filename}: {e}")

if __name__ == "__main__":
    generate_audio()