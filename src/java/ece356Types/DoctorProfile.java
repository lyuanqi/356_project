/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ece356Types;

import java.util.ArrayList;

/**
 *
 * @author liyuanqi
 */
public class DoctorProfile {
    public String alias;
    public String name;
    public String gender;
    public ArrayList<String> addresses =new ArrayList<String>();
    public ArrayList<String> specializations =new ArrayList<String>();
    public int years_licensed;
    public double avg_rating;
    public int review_count;
    public ArrayList<String> review_links =new ArrayList<String>();
    public String write_link;
    public String profile_link;
}
