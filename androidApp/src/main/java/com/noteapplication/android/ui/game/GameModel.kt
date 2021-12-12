package com.noteapplication.android.ui.game

import androidx.annotation.DrawableRes
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.noteapplication.android.R
import com.noteapplication.android.utils.SingleLiveEvent

class GameModel : ViewModel()  {
    /**
     * Отображение состояния поля
     */
    private lateinit var matrix: Array<CellState>

    /**
     * Текущий ход
     */
    private lateinit var currentCellState: CellState

    /**
     * Ход, где отображаться будет для вьюшки
     */
    val cellStateByIndex: MutableLiveData<Pair<Int, CellState>> = SingleLiveEvent()

    /**
     * Состояние, которое передает для изменения стрелки
     */
    val currentMove: MutableLiveData<CellState> = MutableLiveData()

    init {
        initGame()
    }

    private fun initGame() {
        matrix = Array(9) { CellState.None }
        currentCellState = CellState.Close

        currentMove.value = currentCellState
    }

    fun onCellClick(index: Int) {
        println(R.drawable.ic_circle)
        matrix[index] = currentCellState

        cellStateByIndex.value = Pair(index, currentCellState)
        currentCellState = if (currentCellState == CellState.Close) CellState.Circle else CellState.Close
        currentMove.value = currentCellState
    }

    enum class CellState(@DrawableRes val icon: Int, val isClickable: Boolean) {
        None(0, true),
        Circle(R.drawable.ic_circle, false),
        Close(R.drawable.ic_close, false)
    }
}