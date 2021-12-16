import path from "path";
import jsonfile from "jsonfile";
const __dirname = path.resolve();

const calculateStandardAnswer = res => {
  return {
    acc: res === "yes" ? 1 : 0,
    tot: res === "yes" || res === "no" ? 1 : 0,
  };
};

const unpaidHours = res => {
  return {
    acc: res === "no" ? 1 : 0,
    tot: res === "yes" || res === "no" ? 1 : 0,
  };
};

const exceedHours = (contracted, worked) => {
  return {
    acc:
      typeof contracted === "number" &&
      typeof worked === "number" &&
      Math.abs(contracted - worked) <= 8
        ? 1
        : 0,
  };
};

const minRateCheck = wage => {
  const money = parseFloat(wage.replace("£", ""));
  return {
    acc: money > 8.21 && money != "" ? 1 : 0,
  };
};

function percentage(accumulator, total) {
  return accumulator / total * 100;
}

const printResults = (acc, tot) => {
  // eslint-disable-next-line no-console
  console.log(
    "Score is %d/%d (%d%)",
    acc,
    tot,
    Math.trunc(percentage(acc, tot))
  );
};

export const calculateScore = obj => {
  let acc = 0;
  let tot = 0;
  Object.entries(obj).map(([key, value]) => {
    if (key === "enjoys_job") {
      const { tot: total, acc: accu } = calculateStandardAnswer(value);
      tot += total;
      acc += accu;
    }
    if (key === "respected_by_managers") {
      const { tot: total, acc: accu } = calculateStandardAnswer(value);
      tot += total;
      acc += accu;
    }
    if (key === "good_for_carers") {
      const { tot: total, acc: accu } = calculateStandardAnswer(value);
      tot += total;
      acc += accu;
    }
    if (key === "contracted_hours") {
      const { acc: accu } = exceedHours(value, obj["hours_actually_worked"]);
      acc += accu;
      tot += 1;
    }
    if (key === "unpaid_extra_work") {
      const { tot: total, acc: accu } = unpaidHours(value);
      tot += total;
      acc += accu;
    }
    if (key === "hourly_rate") {
      const { acc: accu } = minRateCheck(value);
      tot += 1;
      acc += accu;
    }
  });

  process.argv[3] === "--print" ? printResults(acc, tot) : null;

  return {
    acc,
    tot,
  };
};

if (process.argv[2]) {
  let file = process.argv[2];
  let file_path = path.join(__dirname, file);
  let json = jsonfile.readFileSync(file_path);
  calculateScore(json);
}
