import { calculateScore } from "../src/v2";

describe("hello", () => {
  test("acc that returns 3", () => {
    const input = {
      enjoys_job: "yes",
      respected_by_managers: "no",
      good_for_carers: "yes",
      contracted_hours: 20,
      hours_actually_worked: 34,
      unpaid_extra_work: "unsure",
      age: 26,
      hourly_rate: "£8.22",
      submitted_date: 1608211454000,
    };
    const accExpected = 3;
    const { acc } = calculateScore(input);
    expect(acc).toBe(accExpected);
  });
  test("acc that returns 1", () => {
    const input = {
      enjoys_job: "no",
      respected_by_managers: "no",
      good_for_carers: "no",
      contracted_hours: 20,
      hours_actually_worked: 34,
      unpaid_extra_work: "unsure",
      age: 26,
      hourly_rate: "£8.22",
      submitted_date: 1608211454000,
    };
    const accExpected = 1;
    const { acc } = calculateScore(input);
    expect(acc).toBe(accExpected);
  });
  test("acc returns 0", () => {
    const input = {
      enjoys_job: "no",
      respected_by_managers: "no",
      good_for_carers: "no",
      contracted_hours: 20,
      hours_actually_worked: 34,
      unpaid_extra_work: "unsure",
      age: 26,
      hourly_rate: "£8.20",
      submitted_date: 1608211454000,
    };
    const accExpected = 0;
    const { acc } = calculateScore(input);
    expect(acc).toBe(accExpected);
  });
  test("acc returns 5", () => {
    const input = {
      enjoys_job: "yes",
      respected_by_managers: "yes",
      good_for_carers: "yes",
      contracted_hours: 20,
      hours_actually_worked: 34,
      unpaid_extra_work: "no",
      age: 26,
      hourly_rate: "£8.22",
      submitted_date: 1608211454000,
    };
    const accExpected = 5;
    const { acc } = calculateScore(input);
    expect(acc).toBe(accExpected);
  });
  test("acc returns 0", () => {
    const input = {
      enjoys_job: "asdfasfd",
      respected_by_managers: "asdfasdfa",
      good_for_carers: "asdfasdf",
      contracted_hours: "",
      hours_actually_worked: "",
      unpaid_extra_work: "nosadfasf",
      age: "",
      hourly_rate: "£",
      submitted_date: 1608211454000,
    };
    const accExpected = 0;
    const { acc } = calculateScore(input);
    expect(acc).toBe(accExpected);
  });
});
