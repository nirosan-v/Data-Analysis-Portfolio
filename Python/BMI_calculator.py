# Input name, height and weight
name = input("Enter your name:")
height_cm = float(input("Enter your height in centimetres: "))
weight_kg = float(input("Enter your weight in kilograms: "))

# Calculate height in metres and BMI
height_m = height_cm / 100
bmi = weight_kg / (height_m * height_m)

# Check the BMI category
if bmi < 18.5:
    print(name+", you are underweight.")
elif bmi <= 24.9:
    print(name+", you are normal weight.")
elif bmi <= 29.9:
    print(name+", you are overweight.")
elif bmi <= 34.9:
    print(name+", you are obese.")
else:
    print(name+", you are severely obese.")

# Output BMI result
print("Your BMI is "+str(bmi)+".")