package com.noteapplication.android.ui.game

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.core.view.forEachIndexed
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import com.noteapplication.android.databinding.FragmentGameBinding

class GameFragment : Fragment()  {
    companion object {
        fun newInstance() = GameFragment()
    }

    private lateinit var binding: FragmentGameBinding
    private val viewModel: GameModel by viewModels()


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setHasOptionsMenu(true)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentGameBinding.inflate(inflater, container, false)

        return binding.root
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.field.forEachIndexed { index, view ->
            view.setOnClickListener { viewModel.onCellClick(index) }
        }

        viewModel.currentMove.observe(viewLifecycleOwner) {
            binding.arrow.animate()
                .rotation(if (it == GameModel.CellState.Close) 0f else 180f)
        }

        viewModel.cellStateByIndex.observe(viewLifecycleOwner) {
            val (index, state) = it
            with(binding.field.getChildAt(index) as ImageView) {
                isEnabled = state.isClickable
                setImageResource(state.icon)
            }
        }
    }
}