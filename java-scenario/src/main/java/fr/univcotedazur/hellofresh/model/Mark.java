package fr.univcotedazur.hellofresh.model;

import java.util.Objects;

public class Mark implements Comparable<Mark> {

    private int sumMarks, numberFeedbacks;

    public Mark(int sumMarks, int numberFeedbacks) {
        this.sumMarks = sumMarks;
        this.numberFeedbacks = numberFeedbacks;
    }

    public int getSumMarks() {
        return sumMarks;
    }

    public int getNumberFeedbacks() {
        return numberFeedbacks;
    }

    public Mark addFeedback(int mark) {
        sumMarks += mark;
        numberFeedbacks++;
        return this;
    }

    public double getAverageMark() {
        return (double) sumMarks / numberFeedbacks;
    }

    @Override
    public int compareTo(Mark o) {
        return Double.compare(this.getAverageMark(), o.getAverageMark());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Mark mark = (Mark) o;
        return sumMarks == mark.sumMarks && numberFeedbacks == mark.numberFeedbacks;
    }

    @Override
    public int hashCode() {
        return Objects.hash(sumMarks, numberFeedbacks);
    }
}
