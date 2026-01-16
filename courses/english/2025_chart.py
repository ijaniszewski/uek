import matplotlib.pyplot as plt

# 1. Pack data into a Python dictionary
strava_data = {
    "Jan": 9,
    "Feb": 9,
    "Mar": 23,
    "Apr": 19,
    "May": 21,
    "Jun": 29,
    "Jul": 28,
    "Aug": 14,
    "Sep": 13,
    "Oct": 11,
    "Nov": 14,
    "Dec": 9,
}

months = list(strava_data.keys())
values = list(strava_data.values())

# 2. Setup the plot
plt.figure(figsize=(10, 6))

# Create bars
bars = plt.bar(months, values, color="#4CAF50")  # Green = Growth/Health

# Add labels and title (Economic Style)
plt.title("Strava Activities: Month by Month", fontsize=14, fontweight="bold")
plt.xlabel("Month", fontsize=12)
plt.ylabel("Activity Count", fontsize=12)

# Remove the black frame (spines)
plt.gca().spines["top"].set_visible(False)
plt.gca().spines["right"].set_visible(False)
plt.gca().spines["left"].set_visible(False)
plt.gca().spines["bottom"].set_visible(False)

# Add grid lines for readability
plt.grid(axis="y", linestyle="--", alpha=0.5)

# Add numbers inside bars (Data Labels)
for bar in bars:
    height = bar.get_height()
    plt.text(
        bar.get_x() + bar.get_width() / 2.0,
        height - 0.5,
        f"{int(height)}",
        ha="center",
        va="top",
        color="white",
        fontweight="bold",
    )

# Add vertical line for main event (start of August)
aug_index = months.index("Aug")
plt.axvline(x=aug_index - 0.5, color="gray", linestyle="--", linewidth=1, alpha=0.7)

plt.text(
    aug_index - 0.4,
    max(values),
    "IRONMAN 70.3 Kraków\n(3 Aug)",
    color="red",
    fontsize=10,
    fontweight="bold",
    ha="left",
    va="top",
)

# Save plot to file
plt.savefig("2025_activities_chart.png", dpi=300, bbox_inches="tight")

# Show plot
# plt.tight_layout()
# plt.show()
